import SwiftUI
import SwiftData

@main
struct AppEntry: App {
    private let container: ModelContainer = {
        let schema = Schema([CurrencyRateEntity.self])
        let configuration = ModelConfiguration(AppConstants.SwiftDataConfiguration.currencyConfig, schema: schema)
        return try! ModelContainer(for: schema, configurations: [configuration])
    }()

    var body: some Scene {
        WindowGroup {
            AppRoot(container: container)
        }
    }
}
