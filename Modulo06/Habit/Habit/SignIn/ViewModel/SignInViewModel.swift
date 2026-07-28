import SwiftUI
import Observation

@Observable
@MainActor
class SignInViewModel {
    
    var uiState: SignInUIState = .none
    
    func login(email: String, password: String) {
        self.uiState = .loading
        
        Task {
            try? await Task.sleep(for: .seconds(1))
//            self.uiState = .goToHomeScreen
            self.uiState = .error("Usuário ou senha incorreta")
        }
    }
}

extension SignInViewModel {
    func homeView() -> some View {
        return SignInViewRouter.makeHomeView()
    }
}
