protocol OnboardingFlowUseCase {
    var pages: [OnboardingPage] { get }
    func next(currentIndex: Int) -> Int
    func isLastPage(index: Int) -> Bool
}

final class DefaultOnboardingFlowUseCase: OnboardingFlowUseCase {
    let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "onboarding1",
            title: "Track Exchange Rates",
            description: "Stay up-to-date with current exchange rates in real-time."
        ),
        OnboardingPage(
            imageName: "onboarding2",
            title: "Currency Converter",
            description: "Convert between different currencies quickly and easily."
        ),
        OnboardingPage(
            imageName: "onboarding3",
            title: "Market Insights",
            description: "Gain insights into latest trends and market analysis."
        )
    ]

    func next(currentIndex: Int) -> Int {
        min(currentIndex + 1, pages.count - 1)
    }

    func isLastPage(index: Int) -> Bool {
        index == pages.count - 1
    }
}
