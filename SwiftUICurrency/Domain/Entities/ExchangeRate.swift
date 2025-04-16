import Foundation

struct ExchangeRate {
    let timestamp: Date
    let source: String
    let quotes: [CurrencyRate]
    
    struct CurrencyRate: Equatable {
        let pair: String
        let rate: Double
        let diff: Double?
    }
}

extension ExchangeRate: Identifiable {
    var id: String {
        return source + quotes.map(\.pair).joined()
    }
}

extension ExchangeRate.CurrencyRate: Identifiable {
    var id: String { pair }
}
