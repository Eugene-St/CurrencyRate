import Foundation

protocol OnboardingViewModelProtocol: ObservableObject {
    var currentIndex: Int { get set }
    var pages: [OnboardingPage] { get }
    var isLastPage: Bool { get }
    var buttonText: String { get }
    func skip()
    func finishOnboarding()
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    
    // MARK: - Properties
    private weak var navigator: OnboardingNavigation?
    private let useCase: OnboardingFlowUseCase
    @Published var currentIndex: Int = 0
    var pages: [OnboardingPage] {
        useCase.pages
    }

    var isLastPage: Bool {
        useCase.isLastPage(index: currentIndex)
    }
    
    var buttonText: String {
        isLastPage ? "Get Started" : "Next"
    }

    init(useCase: OnboardingFlowUseCase, navigator: OnboardingNavigation) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func finishOnboarding() {
        UserDefaultsManager.shared.setHasFinishedOnboarding(true)
        navigator?.finishOnboarding()
    }
    
    func skip() {
        finishOnboarding()
    }
}

