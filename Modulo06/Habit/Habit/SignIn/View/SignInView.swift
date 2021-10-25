import SwiftUI

struct SignInView: View {
    
    @ObservedObject var viewModel: SignInViewModel
    
    @State var email = ""
    @State var password = ""
    
    @State var action: Int? = 0
    
    @State var navigationHidden = true
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 20, content: {
                    Spacer()
                    VStack(alignment: .center, spacing: 8, content: {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 48)
                        
                        Text("Login")
                            .foregroundColor(.orange)
                            .font(Font.system(.title).bold())
                            .padding(.bottom, 8)
                        
                        numberField
                        
                        passwordField
                        
                        enterButton
                        
                        registerLink
                        
                        Text("Copyright @YYY")
                            .foregroundColor(Color.gray)
                            .font(Font.system(size: 16).bold())
                            .padding(.top, 16)
                    })
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 32)
                .background(Color.white)
                .navigationBarTitle("Login", displayMode: .large)
                .navigationBarHidden(navigationHidden)
            }
        }
    }
}

extension SignInView {
    var numberField: some View {
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
            print("Entrar")
        }
    }
}

extension SignInView {
    var registerLink: some View {
        VStack {
            Text("Ainda não possui um login ativo?")
                .foregroundColor(.gray)
                .padding(.top, 48)
            
            ZStack {
                NavigationLink(
                    destination: Text("Tela de cadastro"),
                    tag: 1,
                    selection: $action,
                    label: {
                        EmptyView()
                    })
                
                Button("Realize seu cadastro") {
                    self.action = 1
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
