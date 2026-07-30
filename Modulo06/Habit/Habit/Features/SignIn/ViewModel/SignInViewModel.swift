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
    
    @MainActor
    func login() async {
        self.uiState = .loading
        
        let result = await AuthenticationService().login(email: email, password: password)

        switch result {
        case .success:
            self.publisher.send(true)
            self.uiState = .goToHomeScreen
        case let .failure(error):
            self.uiState = .error(error.localizedDescription)
        }
    }
}

extension SignInViewModel {
    func homeView() -> some View {
        return SignInViewRouter.makeHomeView()
    }
    
    @MainActor
    func signUpView() -> some View {
        return SignInViewRouter.makeSignUpView(publisher: publisher)
    }
}
