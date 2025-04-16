import SwiftUI

struct OnboardingPageIndicator: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(current == index ? Color.white : Color.white.opacity(0.4))
                    .frame(width: current == index ? 20 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: current)
            }
        }
    }
}

