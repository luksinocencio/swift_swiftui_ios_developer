import SwiftUI
import Combine

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var viewModel: SignInViewModel
    
    @State var email = ""
    @State var password = ""
    
    @State var action: Int? = 0
    
    @State var navigationHidden = true
    
    var body: some View {
        ZStack {
            if case SignInUIState.goToHomeScreen = viewModel.uiState {
                viewModel.homeView()
            } else {
                NavigationStack {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center, spacing: 20) {
                            Spacer(minLength: 36)
                            
                            VStack(alignment: .center, spacing: 8) {
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, 48)
                                
                                Text("Login")
                                    .foregroundColor(.orange)
                                    .font(Font.system(.title).bold())
                                    .padding(.bottom, 8)
                                
                                emailField
                                
                                passwordField
                                
                                enterButton
                                
                                registerLink
                                
                                Text("Copyright @YYY")
                                    .foregroundColor(Color.gray)
                                    .font(Font.system(size: 13).bold())
                                    .padding(.top, 16)
                            }
                            
                        }
                        
                        if case SignInUIState.error(let value) = viewModel.uiState {
                            Text("")
                                .alert(isPresented: .constant(true)) {
                                    Alert(title: Text("Habit"), message: Text(value), dismissButton: .default(Text("Ok")) {
                                        // faz algo quando some o alerta
                                    })
                                }
                        }
                    }
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                    .padding(.horizontal, 32)
                    .navigationBarTitle("Login", displayMode: .inline)
                    .navigationBarHidden(navigationHidden)
                }
                .onAppear {
                    self.navigationHidden = true
                }
                .onDisappear {
                    self.navigationHidden = false
                }
            }
        }
    }
}

extension SignInView {
    var emailField: some View {
        EditTextView(
            placeholder: "E-mail",
            text: $email,
            keyboard: .emailAddress,
            error: "E-mail inválido",
            failure: !email.isEmail()
        )
    }
}

extension SignInView {
    var passwordField: some View {
        EditTextView(
            placeholder: "Senha",
            text: $password,
            keyboard: .emailAddress,
            error: "Senha deve ter ao menos 8 caracteres.",
            failure: password.count < 8,
            isSecure: true
        )
    }
}

extension SignInView {
    var enterButton: some View {
        LoadingButtonView(
            text: "Entrar",
            action: {
                viewModel.login(email: email, password: password)
            },
            showProgress: self.viewModel.uiState == SignInUIState.loading,
            disabled: !email.isEmail() || password.count < 8
        )
    }
}

extension SignInView {
    var registerLink: some View {
        VStack {
            Text("Ainda não possui um login ativo?")
                .foregroundColor(.gray)
                .padding(.top, 48)
            
            ZStack {
                NavigationLink {
                    viewModel.signUpView()
                } label: {
                    Text("Realize seu cadastro")
                }
            }
        }
    }
}

#Preview {
    SignInView(viewModel: SignInViewModel())
}

#Preview {
    SignInView(viewModel: SignInViewModel())
        .preferredColorScheme(.dark)
}
