import SwiftUI

protocol OnboardingFlowOutput {
    var didFinishOnboardingFlow: CompletionBlock? { get set }
}

final class OnboardingCoordinator: BaseCoordinator, OnboardingFlowOutput {
    @Published var path = NavigationPath()
    var container: OnboardingDIContainer?
    var didFinishOnboardingFlow: (() -> Void)?
    
    func setContainer(_ container: OnboardingDIContainer) {
        self.container = container
    }
    
    func finish() {
        didFinishOnboardingFlow?()
    }
    
    func makeOnboardingSceneView() -> some View {
        container?.makeOnboardingScene()
    }
}

extension OnboardingCoordinator: OnboardingNavigation {
    func finishOnboarding() {
        finish()
    }
}
