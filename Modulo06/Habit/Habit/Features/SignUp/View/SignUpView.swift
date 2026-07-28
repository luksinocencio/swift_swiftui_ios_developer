import SwiftUI
import Combine


import SwiftUI

struct SignUpView: View {
    @State var fullName = ""
    @State var email = ""
    @State var password = ""
    @State var document = ""
    @State var phone = ""
    @State var birthday = ""
    @State var gender = Gender.male
    
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .center) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Cadastro")
                            .foregroundColor(Color("textColor"))
                            .font(Font.system(.title).bold())
                            .padding(.bottom, 8)
                        
                        fullNameField
                        
                        emailField
                        
                        passwordField
                        
                        documentField
                        
                        phoneField
                        
                        birthdayField
                        
                        genderField
                        
                        saveButton
                        
                    }
                    
                    Spacer()
                }.padding(.horizontal, 8)
                
            }.padding()
            
            if case SignUpUIState.error(let value) = viewModel.uiState {
                Text("")
                    .alert(isPresented: .constant(true)) {
                        Alert(title: Text("Habit"), message: Text(value), dismissButton: .default(Text("Ok")) {
                            // faz algo quando some o alerta
                        })
                    }
            }
        }
    }
}

extension SignUpView {
    var fullNameField: some View {
        EditTextView(
            placeholder: "Entre com seu nome completo *",
            text: $fullName,
            keyboard: .alphabet,
            error: "e-mail inválido",
            failure: fullName.count < 3
        )
    }
}

extension SignUpView {
    var emailField: some View {
        EditTextView(
            placeholder: "Entre com seu e-mail *",
            text: $email,
            keyboard: .emailAddress,
            error: "e-mail inválido",
            failure: !email.isEmail()
        )
    }
}

extension SignUpView {
    var passwordField: some View {
        EditTextView(
            placeholder: "Entre com sua senha *",
            text: $password,
            keyboard: .emailAddress,
            error: "senha deve ter ao menos 8 caracteres",
            failure: password.count < 8,
            isSecure: true
        )
    }
}

extension SignUpView {
    var documentField: some View {
        EditTextView(
            placeholder: "Entre com seu CPF *",
            text: $document,
            keyboard: .numberPad,
            error: "CPF inválido",
            failure: document.count != 11
        )
        // TODO: mask
        // TODO: isDisabled
    }
}

extension SignUpView {
    var phoneField: some View {
        EditTextView(
            placeholder: "Entre com seu celular *",
            text: $phone,
            keyboard: .numberPad,
            error: "Entre com o DDD + 8 ou 9 digitos",
            failure: phone.count < 10 || phone.count >= 12
        )
        // TODO: mask
    }
}

extension SignUpView {
    var birthdayField: some View {
        EditTextView(
            placeholder: "Entre com com sua data de nascimento *",
            text: $birthday,
            keyboard: .default,
            error: "Data deve ser dd/MM/yyyy",
            failure: birthday.count != 10
        )
        // TODO: mask
    }
}

extension SignUpView {
    var genderField: some View {
        Picker("Gender", selection: $gender) {
            ForEach(Gender.allCases, id: \.self) { value in
                Text(value.rawValue)
                    .tag(value)
            }
        }.pickerStyle(SegmentedPickerStyle())
            .padding(.top, 16)
            .padding(.bottom, 32)
    }
}

extension SignUpView {
    var saveButton: some View {
        LoadingButtonView(
            text: "Realize o seu Cadastro",
            action: {
                viewModel.signUp()
            },
            showProgress: self.viewModel.uiState == SignUpUIState.loading,
            disabled: !email.isEmail() ||
            password.count < 8 ||
            fullName.count < 3 ||
            document.count != 11 ||
            phone.count < 10 || phone.count >= 12 ||
            birthday.count != 10
        )
    }
}

#Preview {
    let viewModel = SignUpViewModel()
    SignUpView(viewModel: viewModel)
}
