import SwiftUI

final class OnboardingDIContainer {
    
    private let navigator: OnboardingNavigation
    private let useCase: OnboardingFlowUseCase = DefaultOnboardingFlowUseCase()
    
    init(navigator: OnboardingNavigation) {
        self.navigator = navigator
    }
    
    func makeOnboardingScene() -> some View {
        OnboardingScene(viewModel: makeOnboardingViewModel(navigator: navigator))
    }
    
    // MARK: - Private
    private func makeOnboardingViewModel(navigator: OnboardingNavigation) -> OnboardingViewModel {
        OnboardingViewModel(
            useCase: useCase,
            navigator: navigator
        )
    }
}
