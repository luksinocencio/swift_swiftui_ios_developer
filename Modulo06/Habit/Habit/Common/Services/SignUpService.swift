import Foundation

struct SignUpService {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func signUp(request: SignUpRequest) async -> Result<Void, NetworkError> {
        let result: Result<Void, NetworkError> = await apiClient.request(SignUpEndpoint.postUser(request))

        return result
    }
}
