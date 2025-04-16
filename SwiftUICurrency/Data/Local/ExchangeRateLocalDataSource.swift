import Foundation
import SwiftData

protocol ExchangeRateLocalDataSource {
    func save(_ currencies: [CurrencyRateEntity]) async throws
    func getAll() async throws -> [CurrencyRateEntity]
    func deleteAll() async throws
    func delete(pair: String) async throws
}

final class ExchangeRateLocalDataSourceImpl: ExchangeRateLocalDataSource {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    @MainActor
    func save(_ currencies: [CurrencyRateEntity]) async throws {
        try await deleteAll()
        for currency in currencies {
            context.insert(currency)
        }
        try context.save()
    }
    
    func getAll() async throws -> [CurrencyRateEntity] {
        let descriptor = FetchDescriptor<CurrencyRateEntity>()
        let result = try context.fetch(descriptor)
        return result
    }
    
    func deleteAll() async throws {
        let all = try await getAll()
        for item in all {
            context.delete(item)
        }
    }
    
    func delete(pair: String) async throws {
        let descriptor = FetchDescriptor<CurrencyRateEntity>(
            predicate: #Predicate { $0.pair == pair }
        )
        let toDelete = try context.fetch(descriptor)
        for item in toDelete {
            context.delete(item)
        }
        try context.save()
    }
    
}
