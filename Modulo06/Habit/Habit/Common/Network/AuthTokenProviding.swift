import Foundation

/// Abstração para o fornecimento do token de autenticação.
/// Cada app decide de onde o token vem (Keychain, UserDefaults, memória etc.).
public protocol AuthTokenProviding: Sendable {
    func token() -> String?
}
