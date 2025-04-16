import Foundation
import SwiftData

@Model
final class SelectedCurrencyEntity {
    @Attribute(.unique) var pair: String
    var rate: Double
    var diff: Double

    init(pair: String, rate: Double, diff: Double) {
        self.pair = pair
        self.rate = rate
        self.diff = diff
    }
}
