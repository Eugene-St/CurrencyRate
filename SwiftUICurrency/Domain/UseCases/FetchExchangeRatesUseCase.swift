import Foundation

protocol FetchExchangeRatesUseCase {
    func execute() async throws -> (rates: [ExchangeRate.CurrencyRate], timestamp: Date)
    func remove(pair: String) async throws
}

final class FetchExchangeRatesUseCaseImpl: FetchExchangeRatesUseCase {
    private let repository: ExchangeRateRepository

    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    func execute() async throws -> (rates: [ExchangeRate.CurrencyRate], timestamp: Date) {
        try await repository.getSelectedRates()
    }

    func remove(pair: String) async throws {
        try await repository.removeCurrencyPair(pair)
    }
}
