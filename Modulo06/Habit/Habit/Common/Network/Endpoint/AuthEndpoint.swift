import Foundation

enum AuthEndpoint: Endpoint {
    case login(SignInRequest)
    
    var baseURL: URL {
        Constants.API.baseURL
    }

    var path: String {
        switch self {
        case .login:
            "/auth/login"
        }
    }

    var method: HTTPMethod {
        .post
    }

    var headers: [String: String] {
        switch self {
        case .login:
            [
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept": "application/json"
            ]
        }
    }

    var body: Data? {
        switch self {
        case let .login(request):
            request.formURLEncodedBody()
        }
    }
}
