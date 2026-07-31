import Combine
import SwiftUI

struct SignUpView: View {
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
            text: $viewModel.fullName,
            keyboard: .alphabet,
            error: "e-mail inválido",
            failure: viewModel.fullName.count < 3
        )
    }
}

extension SignUpView {
    var emailField: some View {
        EditTextView(
            placeholder: "Entre com seu e-mail *",
            text: $viewModel.email,
            keyboard: .emailAddress,
            error: "e-mail inválido",
            failure: !viewModel.email.isEmail(),
            autocapitalization: .none
        )
    }
}

extension SignUpView {
    var passwordField: some View {
        EditTextView(
            placeholder: "Entre com sua senha *",
            text: $viewModel.password,
            keyboard: .emailAddress,
            error: "senha deve ter ao menos 8 caracteres",
            failure: viewModel.password.count < 8,
            isSecure: true
        )
    }
}

extension SignUpView {
    var documentField: some View {
        EditTextView(
            placeholder: "Entre com seu CPF *",
            text: $viewModel.document,
            keyboard: .numberPad,
            error: "CPF inválido",
            failure: viewModel.document.digitsOnly.count != 11
        )
        .onChange(of: viewModel.document) { _, newValue in
            let masked = newValue.maskedCPF
            if masked != newValue {
                viewModel.document = masked
            }
        }
        // TODO: isDisabled
    }
}

extension SignUpView {
    var phoneField: some View {
        EditTextView(
            placeholder: "Entre com seu celular *",
            text: $viewModel.phone,
            keyboard: .numberPad,
            error: "Entre com o DDD + 8 ou 9 digitos",
            failure: viewModel.phone.digitsOnly.count < 10 || viewModel.phone.digitsOnly.count >= 12
        )
        .onChange(of: viewModel.phone) { _, newValue in
            let masked = newValue.maskedPhone
            if masked != newValue {
                viewModel.phone = masked
            }
        }
    }
}

extension SignUpView {
    var birthdayField: some View {
        EditTextView(
            placeholder: "Entre com com sua data de nascimento *",
            text: $viewModel.birthday,
            keyboard: .numberPad,
            error: "Data deve ser dd/MM/yyyy",
            failure: viewModel.birthday.count != 10
        )
        .onChange(of: viewModel.birthday) { _, newValue in
            let masked = newValue.maskedBirthday
            if masked != newValue {
                viewModel.birthday = masked
            }
        }
    }
}

extension SignUpView {
    var genderField: some View {
        Picker("Gender", selection: $viewModel.gender) {
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
                Task { await viewModel.signUp() }
            },
            showProgress: self.viewModel.uiState == SignUpUIState.loading,
            disabled: !viewModel.email.isEmail() ||
            viewModel.password.count < 8 ||
            viewModel.fullName.count < 3 ||
            viewModel.document.digitsOnly.count != 11 ||
            viewModel.phone.digitsOnly.count < 10 || viewModel.phone.digitsOnly.count >= 12 ||
            viewModel.birthday.count != 10
        )
    }
}

#Preview {
    let viewModel = SignUpViewModel(interactor: SignUpInteractor())
    SignUpView(viewModel: viewModel)
}
