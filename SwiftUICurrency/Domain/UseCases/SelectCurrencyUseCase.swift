protocol SelectCurrencyUseCase {
    func loadSelectableCurrencies() async throws -> [SelectableCurrency]
    func saveSelectedCurrencies(_ selected: [SelectableCurrency]) async throws
}

final class SelectCurrencyUseCaseImpl: SelectCurrencyUseCase {
    private let repository: ExchangeRateRepository

    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    func loadSelectableCurrencies() async throws -> [SelectableCurrency] {
        let live = try await repository.fetchLiveAll()
        let saved = try await repository.getSavedPairs()

        return live.map {
            SelectableCurrency(
                pair: $0.pair,
                source: $0.source,
                target: $0.target,
                isSelected: saved.contains($0.pair)
            )
        }
    }

    func saveSelectedCurrencies(_ selected: [SelectableCurrency]) async throws {
        let entities = selected.map {
            CurrencyRateEntity(
                pair: $0.pair,
                source: $0.source,
                target: $0.target,
                rate: 0,
                diff: nil,
                lastUpdated: .now
            )
        }
        try await repository.saveSelected(entities)
    }
}

