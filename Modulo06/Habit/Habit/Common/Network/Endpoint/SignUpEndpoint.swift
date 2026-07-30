import Foundation

enum SignUpEndpoint: Endpoint {
    case postUser(SignUpRequest)
    
    var baseURL: URL {
        Constants.API.baseURL
    }

    var path: String {
        switch self {
        case .postUser:
            "/users"
        }
    }

    var method: HTTPMethod {
        .post
    }
    
    var headers: [String: String] {
        switch self {
        case .postUser:
            [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        }
    }

    var body: Data? {
        switch self {
        case let .postUser(request):
            try? JSONEncoder().encode(request)
        }
    }
}
