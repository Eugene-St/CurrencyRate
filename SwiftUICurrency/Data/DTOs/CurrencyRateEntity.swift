import SwiftData
import Foundation

@Model
final class CurrencyRateEntity: Identifiable {
    @Attribute(.unique) var id: UUID
    var pair: String
    var source: String
    var target: String
    var rate: Double
    var diff: Double?
    var lastUpdated: Date

    init(
        pair: String,
        source: String,
        target: String,
        rate: Double,
        diff: Double?,
        lastUpdated: Date
    ) {
        self.id = UUID()
        self.pair = pair
        self.source = source
        self.target = target
        self.rate = rate
        self.diff = diff
        self.lastUpdated = lastUpdated
    }
}
