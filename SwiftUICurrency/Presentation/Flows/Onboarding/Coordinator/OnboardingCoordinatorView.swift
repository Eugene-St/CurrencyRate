import SwiftUI

struct OnboardingCoordinatorView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeOnboardingSceneView()
        }
    }
}
