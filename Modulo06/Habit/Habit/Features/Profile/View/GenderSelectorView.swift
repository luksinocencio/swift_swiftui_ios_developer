import SwiftUI

struct GenderSelectorView: View {
    
    @Binding var selectedGender: Gender?
    
    let genders: [Gender]
    let title: String
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(title).textCase(.uppercase)) {
                    List(genders, id: \.id) { item in
                        HStack {
                            Text(item.rawValue)
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(selectedGender == item ? .orange : .white)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if !(selectedGender == item) {
                                selectedGender = item
                            }
                        }
                        
                    }
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
        }
    }
}

#Preview {
    GenderSelectorView(selectedGender: .constant(.female), genders: Gender.allCases, title: "Teste")
}
