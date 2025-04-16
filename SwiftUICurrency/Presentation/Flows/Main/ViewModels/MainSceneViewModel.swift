import SwiftUI
import Combine

protocol MainSceneViewModelProtocol: ObservableObject {
    var items: [ExchangeRate.CurrencyRate] { get }
    var lastUpdated: String { get }
    var isLoading: Bool { get }
    var error: String? { get }
    func loadCurrencies() async
    func remove(_ item: ExchangeRate.CurrencyRate)
    func addCurrencyTapped()
}

final class MainSceneViewModel: MainSceneViewModelProtocol {
    @Published var items: [ExchangeRate.CurrencyRate] = []
    @Published var lastUpdated: String = "--:--"
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private let useCase: FetchExchangeRatesUseCase
    private weak var navigator: MainNavigation?
    private var timer: AnyCancellable?
    
    init(useCase: FetchExchangeRatesUseCase, navigator: MainNavigation) {
        self.useCase = useCase
        self.navigator = navigator
        if AppConstants.Flags.isSimulationMode {
            startSimulatedRefresh()
        } else {
            startAutoRefresh()
        }
    }
    
    func remove(_ item: ExchangeRate.CurrencyRate) {
        Task {
            try? await useCase.remove(pair: item.pair)
            await fetch()
        }
    }
    
    func addCurrencyTapped() {
        navigator?.addCurrencyPressed()
    }
    
    // MARK: - Private Helpers
    @MainActor
    func loadCurrencies() async {
        await fetch()
    }
    
    private func startAutoRefresh() {
        timer = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task { await self?.fetch() }
            }
    }
    
    private func startSimulatedRefresh() {
        timer = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task { await self?.simulateRateChange() }
            }
    }
    
    @MainActor
    private func fetch() async {
        do {
            isLoading = true
            let (rates, timestamp) = try await useCase.execute()
            self.items = sortItems(rates)
            self.lastUpdated = DateFormatter.localizedString(
                from: timestamp,
                dateStyle: .none,
                timeStyle: .short
            )
            self.error = nil
        } catch {
            self.error = "Failed to load data. Please try again."
        }
        isLoading = false
    }
    
    @MainActor
    private func simulateRateChange() {
        let updated = items.map { rate in
            let changePercent = Double.random(in: -0.10...0.10)
            let newRate = rate.rate + (rate.rate * changePercent)
            let diff = newRate - rate.rate
            
            return ExchangeRate.CurrencyRate(
                pair: rate.pair,
                rate: newRate,
                diff: diff
            )
        }
        
        self.items = sortItems(updated)
        self.lastUpdated = DateFormatter.localizedString(
            from: Date(),
            dateStyle: .none,
            timeStyle: .short
        )
    }
    
    private func sortItems(_ items: [ExchangeRate.CurrencyRate]) -> [ExchangeRate.CurrencyRate] {
        return items.sorted { $0.pair < $1.pair }
    }
}

