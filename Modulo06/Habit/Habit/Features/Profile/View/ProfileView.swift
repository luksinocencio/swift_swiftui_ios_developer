import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var disableDone: Bool {
        viewModel.fullNameValidation.failure
        || viewModel.phoneValidation.failure
        || viewModel.birthdayValidation.failure
    }
    
    @State var email = "tiago.aguiar@teste.com.br"
    @State var cpf = "111.222.333-11"
    @State var phone = "(11) 1234-1234"
    @State var birthday = "20/02/1990"
    @State var selectedGender: Gender? = .male
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Form {
                    
                    Section(header: Text("Dados cadastrais")) {
                        HStack {
                            Text("Nome")
                            Spacer()
                            TextField("Digite o nome", text: $viewModel.fullNameValidation.value)
                                .keyboardType(.alphabet)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        if viewModel.fullNameValidation.failure {
                            Text("Nome deve ter mais de 3 caracteres")
                                .foregroundColor(.red)
                        }
                        
                        HStack {
                            Text("E-mail")
                            Spacer()
                            TextField("", text: $email)
                                .disabled(true)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("CPF")
                            Spacer()
                            TextField("", text: $cpf)
                                .disabled(true)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Celular")
                            Spacer()
                            TextField("Digite o seu celular", text: $viewModel.phoneValidation.value)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        if viewModel.phoneValidation.failure {
                            Text("Entre com o DDD + 8 ou 9 digitos")
                                .foregroundColor(.red)
                        }
                        
                        HStack {
                            Text("Data de nascimento")
                            Spacer()
                            TextField("Digite a sua data de nascimento", text: $viewModel.birthdayValidation.value)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        if viewModel.birthdayValidation.failure {
                            Text("Data deve ser dd/MM/yyyy")
                                .foregroundColor(.red)
                        }
                        
                        NavigationLink(
                            destination: GenderSelectorView(selectedGender: $selectedGender,
                                                            genders: Gender.allCases,
                                                            title: "Escolha o gênero"),
                            label: {
                                Text("Gênero")
                                Spacer()
                                Text(selectedGender?.rawValue ?? "")
                            })
                        
                    }
                    
                }
                
            }
            
            .navigationBarTitle(Text("Editar Perfil"), displayMode: .automatic)
            .navigationBarItems(trailing: Button(action: {
                
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(.orange)
            })
                .opacity(disableDone ? 0 : 1)
            )
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}
