protocol CoordinatorFactory {
    func makeOnboardingCoordinator() -> OnboardingCoordinator & OnboardingFlowOutput
    func makeMainCoordinator() -> MainCoordinator
}

final class CoordinatorFactoryImpl: CoordinatorFactory {
    let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    func makeOnboardingCoordinator() -> OnboardingCoordinator & OnboardingFlowOutput {
        let coordinator = OnboardingCoordinator()
        let container = appDIContainer.makeOnboardingDIContainer(navigator: coordinator)
        coordinator.setContainer(container)
        return coordinator
    }
    
    func makeMainCoordinator() -> MainCoordinator {
        let coordinator = MainCoordinator()
        let container = appDIContainer.makeMainDIContainer(navigator: coordinator)
        coordinator.setContainer(container)
        return coordinator
    }
}
