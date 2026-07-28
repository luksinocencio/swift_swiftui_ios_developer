import SwiftUI

struct LoadingButtonView: View {
    var text: String = ""
    var action: () -> Void
    var showProgress: Bool = false
    var disabled: Bool = false
    
    var body: some View {
        ZStack {
            Button {
                action()
            } label: {
                Text(showProgress ? "" : text)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .font(Font.system(.title3).bold())
                    .background(disabled ? Color("lightOrange") : Color.orange)
                    .foregroundStyle(Color.white)
                    .cornerRadius(8.0)
            }
            .disabled(disabled || showProgress)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .foregroundStyle(Color.white)
                .opacity(showProgress ? 1 : 0)
        }
    }
}

#Preview("Light Theme") {
    VStack {
        LoadingButtonView(text: "Button" ,action: {
            print("Hello World!")
        })
    }.padding()
}

#Preview("Dark Theme") {
    VStack {
        LoadingButtonView(
            text: "Button" ,
            action: {
                print("Hello World!")
            },
            showProgress: true,
            disabled: true
        )
    }
    .padding()
    .preferredColorScheme(.dark)
}
