import SwiftUI

struct CurrencyListView: View {
    let items: [ExchangeRate.CurrencyRate]
    let onDelete: (ExchangeRate.CurrencyRate) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(items) { item in
                    SwipeCardRow {
                        CurrencyRow(item: item)
                    } onDelete: {
                        onDelete(item)
                    }
                    .padding(.horizontal)
                    .transition(.asymmetric(
                        insertion: .identity,
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
                }
            }
            .padding(.top)
        }
        .animation(.easeInOut, value: items)
    }
}
