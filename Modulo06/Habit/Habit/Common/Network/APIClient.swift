import Foundation

protocol APIClientProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint) async -> Result<T, NetworkError>
    func request(_ endpoint: Endpoint) async -> Result<Void, NetworkError>
}

struct APIClient: APIClientProtocol {
    private let session: URLSession
    private let tokenProvider: AuthTokenProviding?
    private let tokenRefresher: AuthTokenRefreshing?
    private let makeDecoder: @Sendable () -> JSONDecoder

    init(
        session: URLSession = .shared,
        tokenProvider: AuthTokenProviding? = nil,
        tokenRefresher: AuthTokenRefreshing? = nil,
        makeDecoder: @escaping @Sendable () -> JSONDecoder = { JSONDecoder() }
    ) {
        self.session = session
        self.tokenProvider = tokenProvider
        self.tokenRefresher = tokenRefresher
        self.makeDecoder = makeDecoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async -> Result<T, NetworkError> {
        switch await performRequest(endpoint) {
        case let .success(data):
            return decode(data)
        case let .failure(error):
            return .failure(error)
        }
    }

    /// Variante para respostas sem corpo relevante (204 No Content, DELETE etc.).
    func request(_ endpoint: Endpoint) async -> Result<Void, NetworkError> {
        switch await performRequest(endpoint) {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    private func performRequest(_ endpoint: Endpoint, allowRefresh: Bool = true) async -> Result<Data, NetworkError> {
        let urlRequest: URLRequest
        do {
            urlRequest = try authorizedRequest(for: endpoint)
        } catch {
            return .failure(.invalidURL)
        }

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }

            // Um 401 no meio da sessão tenta renovar o token e refaz a
            // requisição original uma única vez — sem isso, a sessão "morre"
            // silenciosamente assim que o accessToken expira.
            if httpResponse.statusCode == 401, allowRefresh, let tokenRefresher {
                guard await tokenRefresher.refreshAccessToken() else {
                    return .failure(.unacceptableStatusCode(401, message: NetworkError.serverMessage(from: data)))
                }
                return await performRequest(endpoint, allowRefresh: false)
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                return .failure(.unacceptableStatusCode(httpResponse.statusCode, message: NetworkError.serverMessage(from: data)))
            }

            return .success(data)
        } catch {
            return .failure(.requestFailed)
        }
    }

    private func authorizedRequest(for endpoint: Endpoint) throws -> URLRequest {
        var request = try endpoint.asURLRequest()

        if let token = tokenProvider?.token(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func decode<T: Decodable>(_ data: Data) -> Result<T, NetworkError> {
        do {
            let decoded = try makeDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.decodingFailed)
        }
    }
}
