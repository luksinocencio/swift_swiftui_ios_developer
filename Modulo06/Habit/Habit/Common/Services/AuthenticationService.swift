import Foundation

struct AuthenticationService {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func login(email: String, password: String) async -> Result<SignInResponse, NetworkError> {
        let request = SignInRequest(email: email, password: password)
        let result: Result<SignInResponse, NetworkError> = await apiClient.request(AuthEndpoint.login(request))

        return result
    }
}
