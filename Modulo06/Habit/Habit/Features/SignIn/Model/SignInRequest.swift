import Foundation

struct SignInRequest {
    let email: String
    let password: String

    /// A API de login espera os campos OAuth2 no formato
    /// `application/x-www-form-urlencoded`, não JSON.
    func formURLEncodedBody() -> Data? {
        let parameters: [(String, String)] = [
            ("grant_type", "password"),
            ("username", email),
            ("password", password),
            ("scope", ""),
            ("client_id", ""),
            ("client_secret", "")
        ]

        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "-._~")

        let encoded = parameters
            .map { key, value in
                let escapedKey = key.addingPercentEncoding(withAllowedCharacters: allowed) ?? key
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
                return "\(escapedKey)=\(escapedValue)"
            }
            .joined(separator: "&")

        return encoded.data(using: .utf8)
    }
}
