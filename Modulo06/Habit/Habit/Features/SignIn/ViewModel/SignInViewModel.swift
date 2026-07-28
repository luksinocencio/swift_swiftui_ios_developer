import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    
    private var cancellable: AnyCancellable?
    
    private let publisher = PassthroughSubject<Bool, Never>()
    
    @Published var uiState: SignInUIState = .none
    @Published var email = ""
    @Published var password = ""
    
    init() {
        cancellable = publisher.sink { value in
            print("usuário criado! goToHome: \(value)")
            
            if value {
                self.uiState = .goToHomeScreen
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func login() {
        self.uiState = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.uiState = .goToHomeScreen
        }
    }
    
}

extension SignInViewModel {
    func homeView() -> some View {
        return SignInViewRouter.makeHomeView()
    }
    func signUpView() -> some View {
        return SignInViewRouter.makeSignUpView(publisher: publisher)
    }
}
