import Foundation
import Combine

class HabitViewModel: ObservableObject {
    @Published var uiState: HabitUIState = .emptyList
    @Published var title = "Atenção"
    @Published var headline = "Fique ligado!"
    @Published var desc = "Você está atrasado nos hábitos"
}
