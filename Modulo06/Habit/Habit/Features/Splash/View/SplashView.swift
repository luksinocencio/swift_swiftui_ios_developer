import SwiftUI
import Combine

struct SplashView: View {
  
  @ObservedObject var viewModel: SplashViewModel

  var body: some View {
    Group {
      switch viewModel.uiState {
        case .loading:
          loadingView()
        case .goToSignInScreen:
          // navegar para proxima tela
          viewModel.signInView()
          
        case .goToHomeScreen:
          Text("carregar tela principal")
        // navegar para proxima tela
        case .error(let msg):
          loadingView(error: msg)
      }
    }.onAppear(perform: viewModel.onAppear)
  }
  
}

extension SplashView {
  func loadingView(error: String? = nil) -> some View {
    ZStack {
      Image("logo")
        .resizable()
        .scaledToFit()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .ignoresSafeArea()
      
      if let error = error {
        Text("")
          .alert(isPresented: .constant(true)) {
            Alert(title: Text("Habit"), message: Text(error), dismissButton: .default(Text("Ok")) {
              // faz algo quando some o alerta
            })
          }
       }
    }
  }
}


#Preview("Light Theme") {
    let viewModel = SplashViewModel(interactor: SplashInteractor())
    SplashView(viewModel: viewModel)
}

#Preview("Dark Theme") {
    let viewModel = SplashViewModel(interactor: SplashInteractor())
    SplashView(viewModel: viewModel)
        .preferredColorScheme(.dark)
}
