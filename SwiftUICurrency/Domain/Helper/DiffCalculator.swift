import Foundation

struct DiffCalculator {
    static func calculateDiff(
        live: ExchangeRateDTO,
        historical: ExchangeRateDTO
    ) -> [ExchangeRate.CurrencyRate] {
        var result: [ExchangeRate.CurrencyRate] = []

        for (pair, liveRate) in live.quotes {
            if let historicalRate = historical.quotes[pair] {
                let diff = liveRate - historicalRate
                result.append(ExchangeRate.CurrencyRate(pair: pair, rate: liveRate, diff: diff))
            }
        }
        return result
    }
}
