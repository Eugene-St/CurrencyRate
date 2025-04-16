import Foundation

protocol SelectCurrencyViewModelProtocol: ObservableObject {
    var currencies: [SelectableCurrency] { get }
    func toggleSelection(for item: SelectableCurrency)
    func saveSelection() async
    func load() async
}

final class SelectCurrencyViewModel: SelectCurrencyViewModelProtocol {
    @Published var currencies: [SelectableCurrency] = []
    private let useCase: SelectCurrencyUseCase
    private weak var navigator: MainNavigation?
    
    init(useCase: SelectCurrencyUseCase, navigator: MainNavigation?) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func toggleSelection(for item: SelectableCurrency) {
        guard let index = currencies.firstIndex(where: { $0.pair == item.pair }) else { return }
        currencies[index].isSelected.toggle()
    }
    
    func saveSelection() async {
        let selected = currencies.filter { $0.isSelected }
        try? await useCase.saveSelectedCurrencies(selected)
    }
    
    func load() async {
        if let result = try? await useCase.loadSelectableCurrencies() {
            await MainActor.run {
                self.currencies = sortItems(result)
            }
        }
    }
    
    private func sortItems(_ items: [SelectableCurrency]) -> [SelectableCurrency] {
        return items.sorted { $0.pair < $1.pair }
    }
}

struct SelectableCurrency: Identifiable {
    let pair: String
    let source: String
    let target: String
    var isSelected: Bool
    var id: String { pair }
}

