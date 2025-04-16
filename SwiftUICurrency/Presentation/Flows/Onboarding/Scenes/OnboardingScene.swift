import SwiftUI

struct OnboardingScene<ViewModel: OnboardingViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isPressed = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                TabView(selection: $viewModel.currentIndex) {
                    ForEach(viewModel.pages.indices, id: \.self) { index in
                        OnboardingPageView(page: viewModel.pages[index], geometry: geometry)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .allowsHitTesting(false)
                if !viewModel.isLastPage {
                    SkipButton {
                        withAnimation { viewModel.skip() }
                    }
                }
                VStack {
                    Spacer()
                    
                    OnboardingPageIndicator(
                        total: viewModel.pages.count,
                        current: viewModel.currentIndex
                    )
                    OnboardingNextButton(
                        isPressed: $isPressed,
                        isLast: viewModel.isLastPage,
                        action: {
                            withAnimation {
                                if viewModel.isLastPage {
                                    viewModel.finishOnboarding()
                                } else {
                                    viewModel.currentIndex += 1
                                }
                            }
                        },
                        geometry: geometry,
                        text: viewModel.buttonText
                    )
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
            .background(
                LinearGradient(colors: [Color.orange, Color.blue], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
    }
}
