import SwiftUI

struct OnboardingNextButton: View {
    @Binding var isPressed: Bool
    let isLast: Bool
    let action: () -> Void
    let geometry: GeometryProxy
    let text: String

    var body: some View {
        Button(action: action) {
            Text(text)
                .fontWeight(.semibold)
                .frame(width: geometry.size.width * 0.75,
                       height: geometry.size.height * 0.09)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(20)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                .frame(maxWidth: .infinity)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

