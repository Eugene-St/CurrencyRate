import SwiftUI

struct SelectCurrencySceneView<ViewModel: SelectCurrencyViewModelProtocol>: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ViewModel
    @State private var isPressed = false
    @State private var searchText: String = ""
    @State private var displayedCurrencies: [SelectableCurrency] = []
    @State private var isLoading: Bool = true

    var body: some View {
        GeometryReader { geometry in
        ZStack {
            LinearGradient(colors: [Color.orange, Color.blue],
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(spacing: 12) {
                SelectCurrencyHeaderView(searchText: $searchText)
                
                if isLoading {
                    Spacer()
                    ProgressView("Loading...")
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(10)
                    Spacer()
                } else {
                    SelectableCurrencyListView(
                        currencies: displayedCurrencies,
                        onToggle: { currency in
                            viewModel.toggleSelection(for: currency)
                            updateDisplayedCurrencies(for: currency.pair)
                        }
                    )
                }
                
                AddCurrencyButton(isPressed: $isPressed,
                                  isDisabled: isLoading,
                                  geometry: geometry) {
                    Task {
                        await viewModel.saveSelection()
                        dismiss()
                    }
                }
            }
        }
    }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                        Text("Back")
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            Task {
                isLoading = true
                await viewModel.load()
                withAnimation(.easeInOut(duration: 0.3)) {
                    displayedCurrencies = viewModel.currencies
                    isLoading = false
                }
            }
        }
        .onChange(of: searchText) { newValue in
            withAnimation(.easeInOut(duration: 0.25)) {
                if newValue.isEmpty {
                    displayedCurrencies = viewModel.currencies
                } else {
                    displayedCurrencies = viewModel.currencies.filter {
                        $0.source.lowercased().contains(newValue.lowercased()) ||
                        $0.target.lowercased().contains(newValue.lowercased())
                    }
                }
            }
        }
    }

    private func updateDisplayedCurrencies(for pair: String) {
        guard let index = displayedCurrencies.firstIndex(where: { $0.pair == pair }) else { return }
        displayedCurrencies[index].isSelected.toggle()
    }
}
