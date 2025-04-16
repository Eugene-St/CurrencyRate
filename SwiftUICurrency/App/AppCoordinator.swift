import SwiftUI

final class AppCoordinator: BaseCoordinator {
    private let factory: CoordinatorFactory
    private(set) var onboardingCoordinator: (OnboardingCoordinator & OnboardingFlowOutput)?
    private(set) var mainCoordinator: MainCoordinator?
    
    @Published var flow: AppFlow? {
        didSet {
            if oldValue != flow {
                startAppropriateFlow()
            }
        }
    }
    
    init(factory: CoordinatorFactory) {
        self.factory = factory
    }
    
    override func start() {
        let hasFinished = UserDefaultsManager.shared.finishedOnboarding()
        flow = hasFinished ? .main : .onboarding
    }
    
    private func startAppropriateFlow() {
        removeAllChildren()
        
        switch flow {
        case .onboarding:
            onboardingCoordinator?.didFinishOnboardingFlow = nil
            onboardingCoordinator = nil
            
            let onboarding = factory.makeOnboardingCoordinator()
            onboarding.didFinishOnboardingFlow = { [weak self] in
                self?.flow = .main
            }
            onboardingCoordinator = onboarding
            addDependency(onboarding)
        case .main:
            mainCoordinator = nil
            let main = factory.makeMainCoordinator()
            mainCoordinator = main
            addDependency(main)
        case .none:
            break
        }
    }
}
