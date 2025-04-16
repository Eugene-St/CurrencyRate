import SwiftData

protocol AppDIContainer {
    func makeOnboardingDIContainer(navigator: OnboardingNavigation) -> OnboardingDIContainer
    func makeMainDIContainer(navigator: MainNavigation) -> MainDIContainer
}

final class AppDIContainerImpl: AppDIContainer {
    
    // MARK: - Shared services
    private let modelContext: ModelContext
    private let networkMonitor: NetworkMonitor = NetworkMonitorImpl()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Flow containers
    func makeOnboardingDIContainer(navigator: OnboardingNavigation) -> OnboardingDIContainer {
        OnboardingDIContainer(navigator: navigator)
    }
    
    func makeMainDIContainer(navigator: MainNavigation) -> MainDIContainer {
        MainDIContainer(modelContext: modelContext,
                        navigator: navigator,
                        networkMonitor: networkMonitor)
    }
}

