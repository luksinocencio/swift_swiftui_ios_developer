import SwiftUI

struct HomeView: View {
    var viewModel: HomeViewModel
    
    var body: some View {
        Text("Hello")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
