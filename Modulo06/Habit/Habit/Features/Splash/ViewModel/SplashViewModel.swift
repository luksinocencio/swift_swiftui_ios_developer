import Combine
import SwiftUI

class SplashViewModel: ObservableObject {
    @Published var uiState: SplashUIState = .loading
    
    private var cancellableAuth: AnyCancellable?
    private let interactor: SplashInteractor
    
    init(interactor: SplashInteractor) {
        self.interactor = interactor
    }
    
    deinit {
        cancellableAuth?.cancel()
    }
    
    func onAppear() {
        cancellableAuth = interactor.fetchAuth()
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .sink { userAuth in
                // se userAuth == nulo -> Login
                if userAuth == nil {
                    self.uiState = .goToSignInScreen
                }
                // senao se userAuth != null && expirou
                else if (Date().timeIntervalSince1970 > Date().timeIntervalSince1970 + Double(userAuth!.expires)) {
                    // chamar o refresh token na API
                    print("token expirou")
                }
                // senao -> Tela princial
                else {
                    self.uiState = .goToHomeScreen
                }
            }
    }
    
}

extension SplashViewModel {
    func signInView() -> some View {
        return SplashViewRouter.makeSignInView()
    }
}
