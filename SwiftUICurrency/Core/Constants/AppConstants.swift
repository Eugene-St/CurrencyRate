typealias CompletionBlock = (() -> Void)
typealias ItemCompletionBlock<Item> = ((Item) -> Void)

enum AppConstants {
    enum UserDefaultsKey {
        static let finishedOnboarding = "hasFinishedOnboarding"
        static let hasPerformedInitialFetch = "hasPerformedInitialFetch"
    }
    
    enum Keys {
        static let accessKey = "80417809896ace207aaccdfb19f98b3a"
    }
    
    enum Flags {
        static let isSimulationMode: Bool = true
        static let simulateNetworkError = false
    }
    
    enum SwiftDataConfiguration {
        static let currencyConfig = "ExchangeDB"
    }
}
