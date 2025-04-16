import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    let geometry: GeometryProxy

    var body: some View {
        VStack(spacing: 16) {
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: geometry.size.height * 0.45)
                .padding(.top, 40)

            VStack(spacing: 8) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Text(page.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
    }
}
