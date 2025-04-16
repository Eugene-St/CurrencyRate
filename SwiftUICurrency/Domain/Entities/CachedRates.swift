struct CachedRates: Codable {
    let date: String
    let base: String
    let rates: [String: Double]
}
