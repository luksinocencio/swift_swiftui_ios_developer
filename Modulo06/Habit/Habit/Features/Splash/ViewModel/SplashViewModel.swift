import SwiftUI
import Combine

class SplashViewModel: ObservableObject {
    
    @Published var uiState: SplashUIState = .loading
    
    func onAppear() {
        // faz algo assincrono e muda o estado da uiState
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.uiState = .goToSignInScreen
        }
    }
    
}

extension SplashViewModel {
    func signInView() -> some View {
        return SplashViewRouter.makeSignInView()
    }
}
