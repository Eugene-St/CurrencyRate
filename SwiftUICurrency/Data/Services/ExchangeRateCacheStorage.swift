import Foundation

protocol ExchangeRateCacheStorageProtocol {
    func save(_ rates: [String: Double], base: String)
    func load() -> CachedRates?
}

final class ExchangeRateCacheStorage: ExchangeRateCacheStorageProtocol {
    private let fileName = "exchange_rates_yesterday.json"

    private var fileURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }

    func save(_ rates: [String: Double], base: String) {
        let wrapper = CachedRates(date: Date.yesterdayString, base: base, rates: rates)
        if let data = try? JSONEncoder().encode(wrapper) {
            try? data.write(to: fileURL)
        }
    }

    func load() -> CachedRates? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(CachedRates.self, from: data)
    }
}
