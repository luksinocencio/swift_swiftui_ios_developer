import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var document = ""
    @Published var phone = ""
    @Published var birthday = ""
    @Published var gender = Gender.male
    
    var publisher: PassthroughSubject<Bool, Never>!
    
    @Published var uiState: SignUpUIState = .none
    
    @MainActor
    func signUp() async {
        self.uiState = .loading
        
        // Pegar a String -> dd/MM/yyyy -> Date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"
        
        guard let dateFormatted = formatter.date(from: birthday) else {
            self.uiState = .error("Data inválida \(birthday)")
            return
        }
        
        // Date -> yyyy-MM-dd -> String
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedBirthday = formatter.string(from: dateFormatted)
        
        let request = SignUpRequest(
            fullName: fullName, email: email, password: password,
            document: document.digitsOnly, phone: phone.digitsOnly, birthday: formattedBirthday,
            gender: gender.index
        )
        
        let result = await SignUpService().signUp(request: request)

        switch result {
        case .success:
            self.publisher.send(true)
            self.uiState = .success
        case let .failure(error):
            self.uiState = .error(error.localizedDescription)
        }
    }
}

extension SignUpViewModel {
    func homeView() -> some View {
        return SignUpViewRouter.makeHomeView()
    }
}
