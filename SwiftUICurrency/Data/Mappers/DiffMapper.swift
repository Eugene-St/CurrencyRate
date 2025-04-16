import Foundation

struct DiffMapper {
    static func toEntity(_ rate: ExchangeRate.CurrencyRate, timestamp: Date, isInitial: Bool = false) -> CurrencyRateEntity {
        CurrencyRateEntity(
            pair: rate.pair,
            source: String(rate.pair.prefix(3)),
            target: String(rate.pair.suffix(3)),
            rate: rate.rate,
            diff: rate.diff ?? 0,
            lastUpdated: timestamp
        )
    }

    static func toDomain(_ entity: CurrencyRateEntity) -> ExchangeRate.CurrencyRate {
        ExchangeRate.CurrencyRate(
            pair: entity.pair,
            rate: entity.rate,
            diff: entity.diff
        )
    }
}
