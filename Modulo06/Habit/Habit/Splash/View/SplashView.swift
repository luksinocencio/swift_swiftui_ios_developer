import SwiftUI

struct SplashView: View {
    
    @ObservedObject var viewModel: SplashViewModel
    
    var body: some View {
        Group {
            switch viewModel.uiState {
            case .loading:
                loadingView()
            case .goToSignInScreen:                
            // navegar para uma proxima tela
                viewModel.signInView()
            case .goToHomeScreen:
                Text("Carregar tela principal")
            // navegar para uma proxima tela
            case .error(let msg):
                loadingView(error: msg)
            }
        }.onAppear(perform: {
            viewModel.onAppear()
        })
    }
}

// 1. Criando um novo componente
// LoadingView()

// 2. variaveis em extensions
//extension SplashView {
//    var loading: some View {
//        Text("Olá")
//    }
//}

// 3. funções em extensions
extension SplashView {
    func loadingView(error: String? = nil) -> some View {
        ZStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.white)
                .ignoresSafeArea()
            
            if let error = error {
                Text("")
                    .alert(isPresented: .constant(true), content: {
                        Alert(title: Text("Habit"), message: Text(error), dismissButton: .default(Text("Ok")){
                            // fazer algo quando sumir o alerta
                        })
                    })
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        //        SplashView(state: .loading)
        let viewModel = SplashViewModel()
        SplashView(viewModel: viewModel)
    }
}
