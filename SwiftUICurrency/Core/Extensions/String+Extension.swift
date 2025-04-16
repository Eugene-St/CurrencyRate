extension String {
    var flagEmoji: String {
        let base: UInt32 = 127397
        let emoji = self.uppercased().unicodeScalars
            .compactMap { UnicodeScalar(base + $0.value) }
            .map { String($0) }
            .joined()
        return String(emoji.prefix(1))
    }
}

