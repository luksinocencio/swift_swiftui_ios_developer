import SwiftUI

struct SignInView: View {
    var viewModel: SignInViewModel
    
    @State var email = ""
    @State var password = ""
    @State var isRegisterActive = false
    @State var navigationHidden = true
    
    var body: some View {
        ZStack {
            if case SignInUIState.goToHomeScreen = viewModel.uiState {
                viewModel.homeView()
            } else {
                NavigationStack {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center, spacing: 20) {
                            Spacer()
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
                                    .font(Font.system(size: 16).bold())
                                    .padding(.top, 16)
                            }
                        }
                        if case SignInUIState.error(let value) = viewModel.uiState {
                            Text("")
                                .alert(isPresented: .constant(true)) {
                                    Alert(title: Text("Habit"), message: Text(value), dismissButton: .default(Text("Ok")){
                                        // fazer algo quando sumir o alerta
                                    })
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 32)
                    .background(Color.white)
                    .navigationBarTitle("Login", displayMode: .large)
                    .navigationBarHidden(navigationHidden)
                    .navigationDestination(isPresented: $isRegisterActive) {
                        Text("Tela de cadastro")
                    }
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
        TextField("E-mail", text: $email)
            .keyboardType(.emailAddress)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
    }
}

extension SignInView {
    var passwordField: some View {
        SecureField("Senha", text: $password)
            .keyboardType(.emailAddress)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

extension SignInView {
    var enterButton: some View {
        Button("Entrar") {
            viewModel.login(email: email, password: password)
        }
        .padding(.top, 24)
        .buttonStyle(.glass)
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
                    Text("Tela de cadastro")
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
