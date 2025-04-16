import SwiftUI

struct MainSceneView<ViewModel: MainSceneViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.orange, Color.blue],
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(spacing: 12) {
                MainSceneHeaderView(onAddTapped: viewModel.addCurrencyTapped)
                LastUpdatedView(text: viewModel.lastUpdated)
                CurrencyListView(items: viewModel.items,
                                 onDelete: viewModel.remove)
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.2).ignoresSafeArea()
                ProgressView("Loading...")
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
            }
        }
        .animation(.easeInOut, value: viewModel.isLoading)
        .onAppear() {
            Task { await viewModel.loadCurrencies() }
        }
        .onChange(of: viewModel.error) { newError in
            showingAlert = newError != nil
        }
        .alert("Error", isPresented: $showingAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(viewModel.error ?? "")
        })
    }
}
