import SwiftUI

struct EditTextView: View {
    var placeholder: String = ""
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var error: String? = nil
    var failure: Bool? = false
    var isSecure: Bool = false
    var autocapitalization: UITextAutocapitalizationType = .words
    var autoCorrection: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .keyboardType(keyboard)
                    .textFieldStyle(CustomTextFieldStyle())
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboard)
                    .textFieldStyle(CustomTextFieldStyle())
                    .autocapitalization(autocapitalization)
                    .autocorrectionDisabled(autoCorrection)
            }
            
            if let error = error, failure == true, !text.isEmpty {
                Text(error).foregroundColor(.red)
            }
        }.padding(.bottom, 10)
    }
}

#Preview("Theme Light") {
    VStack {
        EditTextView(placeholder: "E-mail", text: .constant("meuemail@email.com"))
        EditTextView(placeholder: "Password", text: .constant(""), isSecure: true)
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Theme Dark") {
    VStack {
        EditTextView(placeholder: "E-mail", text: .constant("meuemail@email.com"))
        EditTextView(placeholder: "Password", text: .constant(""), isSecure: true)
    }
    .padding()
    .preferredColorScheme(.dark)
}
