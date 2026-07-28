import SwiftUI

struct SplashView: View {
    
    var viewModel: SplashViewModel
    
    var body: some View {
        Group {
            switch viewModel.uiState {
            case .loading:
                loadingView()
            case .goToSignInScreen:
                viewModel.signInView()
            case .goToHomeScreen:
                Text("Carregar tela principal")
            case .error(let msg):
                loadingView(error: msg)
            }
        }.onAppear(perform: {
            viewModel.onAppear()
        })
    }
}

extension SplashView {
    func loadingView(error: String? = nil) -> some View {
        ZStack {
            VStack(alignment: .center) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                if error == nil {
                    ProgressView()
                        .controlSize(.large)
                }
                
                if let error = error {
                    Text("")
                        .alert(isPresented: .constant(true), content: {
                            Alert(title: Text("Habit"), message: Text(error), dismissButton: .default(Text("Ok")){
                                // fazer algo quando sumir o alerta
                            })
                        })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
        }
    }
}


#Preview {
    let viewModel = SplashViewModel()
    SplashView(viewModel: viewModel)
}
