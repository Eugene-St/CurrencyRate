import SwiftUI
import SwiftData

final class MainDIContainer {
    private let modelContext: ModelContext
    private let navigator: MainNavigation
    private let localDataSource: ExchangeRateLocalDataSource
    private let remoteDataSource: ExchangeRateRemoteDataSource
    private let networkMonitor: NetworkMonitor
    
    init(modelContext: ModelContext,
         navigator: MainNavigation,
         networkMonitor: NetworkMonitor) {
        self.modelContext = modelContext
        self.navigator = navigator
        self.localDataSource = ExchangeRateLocalDataSourceImpl(context: modelContext)
        self.remoteDataSource = ExchangeRateRemoteDataSourceImpl()
        self.networkMonitor = networkMonitor
    }
    
    func makeMainScene(navigator: MainNavigation) -> some View {
        MainSceneView(viewModel: makeMainViewModel(navigator: navigator))
    }
    
    func makeCurrencySelectionScene(navigator: MainNavigation) -> some View {
        SelectCurrencySceneView(viewModel: SelectCurrencyViewModel(
            useCase: makeselectCurrencyUseCase(),
            navigator: navigator)
        )
    }
    
    // MARK: - Private
    private func makeMainViewModel(navigator: MainNavigation) -> MainSceneViewModel {
        .init(useCase: makeFetchExchangeUseCase(), navigator: navigator)
    }
    
    private func makeFetchExchangeUseCase() -> FetchExchangeRatesUseCase {
        FetchExchangeRatesUseCaseImpl(repository: makeExchangeRateRepository())
    }
    
    private func makeExchangeRateRepository() -> ExchangeRateRepository {
        ExchangeRateRepositoryImpl(remoteDataSource: remoteDataSource,
                                   localDataSource: localDataSource,
                                   networkMonitor: networkMonitor)
    }
    
    private func makeselectCurrencyUseCase() -> SelectCurrencyUseCase {
        SelectCurrencyUseCaseImpl(repository: makeExchangeRateRepository())
    }
}
