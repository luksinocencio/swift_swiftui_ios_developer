import SwiftUI
import Combine

@MainActor
class SignUpViewModel: ObservableObject {
    var publisher: PassthroughSubject<Bool, Never>!
    
    @Published var uiState: SignUpUIState = .none
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var document = ""
    @Published var phone = ""
    @Published var birthday = ""
    @Published var gender = Gender.male
    
    func signUp() {
        self.uiState = .loading
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"
        
        let dateFormatted = formatter.date(from: birthday)
        
        guard let dateFormatted = dateFormatted else {
            self.uiState = .error("Data inválida \(birthday)")
            return
        }
        
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedBirthday = formatter.string(from: dateFormatted)
        
        let request = SignUpRequest(
            fullName: fullName,
            email: email,
            password: password,
            document: document,
            phone: phone,
            birthday: formattedBirthday,
            gender: gender.index
        )
        
        Task {
            let result = await WebService.postUser(request: request)
            switch result {
            case .success(let data):
                print("Cadastro realizado com sucesso!")
                self.uiState = .success
            case .failure(let error, let errorData):
                print("Falha no cadastro: \(error)")
                self.uiState = .error("Erro ao realizar cadastro: \(error)")
            }
        }
    }
}

extension SignUpViewModel {
    func homeView() -> some View {
        return SignUpViewRouter.makeHomeView()
    }
}
