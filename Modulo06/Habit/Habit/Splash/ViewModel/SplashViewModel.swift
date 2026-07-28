import SwiftUI
import Observation

@Observable
@MainActor
class SplashViewModel {
    var uiState: SplashUIState = .loading
    
    func onAppear() {
        Task {
            try? await Task.sleep(for: .seconds(3))
            self.uiState = .goToSignInScreen
        }
    }
}

extension SplashViewModel {
    func signInView() -> some View {
        return SplashViewRouter.makeSignInView()
    }
}
