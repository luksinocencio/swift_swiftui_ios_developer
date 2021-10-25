import SwiftUI

struct ContentView: View {
    
    @State var changeText = false
    @State var stepperValue = 10
    
    var body: some View {
        VStack {
            HStack() {
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Botão 1")
                        .foregroundColor(Color.yellow)
                })
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Botão 2")
                        .foregroundColor(Color.red)
                })
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Botão 3")
                        .foregroundColor(Color.green)
                })
                Spacer()
                Stepper(value: $stepperValue, in: 1...10) {
                    Text("Stepper \(self.stepperValue)")
                }
            }.padding(.vertical, 20)
            
            if changeText  {
                Text("Agora é para mostrar")
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
            } else {
                Text("Agora é para mostrar")
                    .fontWeight(.bold)
                    .foregroundColor(Color.green)
            }
            
            Button(action: {
                self.changeText = !self.changeText
            }, label: {
                Text("Clique aqui!")
                    .font(.subheadline)
                    .foregroundColor(Color.blue)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
