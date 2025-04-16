import Foundation

struct ExchangeRateDTO: Decodable {
    let terms: String
    let privacy: String
    let timestamp: TimeInterval
    let source: String
    let quotes: [String: Double]
}

extension ExchangeRateDTO {
    var timestampDate: Date {
        Date(timeIntervalSince1970: timestamp)
    }
}

