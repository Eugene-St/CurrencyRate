import SwiftUI
import SwiftData

struct AppRoot: View {
    let container: ModelContainer

    var body: some View {
        let appDI = AppDIContainerImpl(modelContext: container.mainContext)
        let coordinator = AppCoordinator(
            factory: CoordinatorFactoryImpl(appDIContainer: appDI)
        )

        AppCoordinatorView(coordinator: coordinator)
            .modelContainer(container)
            .onAppear {
                coordinator.start()
            }
    }
}
