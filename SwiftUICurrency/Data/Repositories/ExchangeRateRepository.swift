import Foundation

protocol ExchangeRateRepository {
    // MARK: - Main Scene
    func getSelectedRates() async throws -> (rates: [ExchangeRate.CurrencyRate], timestamp: Date)
    func removeCurrencyPair(_ pair: String) async throws
    
    // MARK: - Currency Selection Scene
    func fetchLiveAll() async throws -> [ExchangeRate.CurrencyRate]
    func getSavedPairs() async throws -> [String]
    func saveSelected(_ items: [CurrencyRateEntity]) async throws
}

final class ExchangeRateRepositoryImpl: ExchangeRateRepository {
    private let remoteDataSource: ExchangeRateRemoteDataSource
    private let localDataSource: ExchangeRateLocalDataSource
    private let network: NetworkMonitor
    
    init(remoteDataSource: ExchangeRateRemoteDataSource,
         localDataSource: ExchangeRateLocalDataSource,
         networkMonitor: NetworkMonitor) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.network = networkMonitor
    }
    
    func getSelectedRates() async throws -> (rates: [ExchangeRate.CurrencyRate], timestamp: Date) {
        let hasDoneInitialFetch = UserDefaultsManager.shared.hasDoneInitialFetch()
        
        if !hasDoneInitialFetch {
            if network.isConnected {
                let defaultPairs = ["USDAED", "USDEUR", "USDBTN"]
                let live = try await remoteDataSource.fetchLive(for: defaultPairs)
                let historical = try await remoteDataSource.fetchHistorical(for: defaultPairs)
                
                let diffRates = DiffCalculator.calculateDiff(live: live, historical: historical)
                
                let updatedEntities = diffRates.map {
                    DiffMapper.toEntity($0, timestamp: live.timestampDate)
                }
                try await localDataSource.save(updatedEntities)
                
                UserDefaultsManager.shared.markInitialFetchDone()
                
                return (diffRates, live.timestampDate)
            } else {
                return ([], Date.distantPast)
            }
        } else {
            let entities = try await localDataSource.getAll()
            if entities.isEmpty {
                return ([], Date.distantPast)
            }
            
            let pairs = entities.map { $0.pair }
            if network.isConnected {
                let live = try await remoteDataSource.fetchLive(for: pairs)
                let historical = try await remoteDataSource.fetchHistorical(for: pairs)
                
                let diffRates = DiffCalculator.calculateDiff(live: live, historical: historical)
                let updatedEntities = diffRates.map {
                    DiffMapper.toEntity($0, timestamp: live.timestampDate)
                }
                try await localDataSource.save(updatedEntities)
                
                return (diffRates, live.timestampDate)
            } else {
                let cached = try await localDataSource.getAll()
                let rates = cached.map { DiffMapper.toDomain($0) }
                return (rates, cached.first?.lastUpdated ?? Date.distantPast)
            }
        }
    }
    
    func removeCurrencyPair(_ pair: String) async throws {
        try await localDataSource.delete(pair: pair)
    }
    
    func fetchLiveAll() async throws -> [ExchangeRate.CurrencyRate] {
        let dto = try await remoteDataSource.fetchLive(for: [])
        return dto.quotes.map { key, value in
            ExchangeRate.CurrencyRate(pair: key, rate: value, diff: nil)
        }
    }
    
    func getSavedPairs() async throws -> [String] {
        let all = try await localDataSource.getAll()
        return all.map { $0.pair }
    }
    
    func saveSelected(_ items: [CurrencyRateEntity]) async throws {
        try await localDataSource.save(items)
    }
}
