import Foundation

enum SignInUIState {
    case none
    case loading
    case goToHomeScreen
    case error(String)
}
