import SwiftUI

struct ContentView: View {
    @State var text = ""
    var body: some View {
        VStack {
            TextField("Informe seu nome", text: $text)
                .padding()
                .border(Color.black)
            
            Text("Olá, \(text)")
                .font(.largeTitle)
                .foregroundColor(Color.purple)
                .multilineTextAlignment(.center)
        }.padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
