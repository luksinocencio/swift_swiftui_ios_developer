import Combine
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        Text("Ola Home Page")
    }
}

#Preview {
    HomeView(viewModel: .init())
}
