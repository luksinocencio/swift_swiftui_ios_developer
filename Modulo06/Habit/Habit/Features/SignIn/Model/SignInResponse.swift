import Foundation

struct SignInResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let expires: Double
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expires
        case tokenType = "token_type"
    }
}
