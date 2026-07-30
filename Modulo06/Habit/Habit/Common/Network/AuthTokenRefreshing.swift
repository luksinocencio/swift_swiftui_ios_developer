import Foundation

protocol AuthTokenRefreshing: Sendable {
    func refreshAccessToken() async -> Bool
}
