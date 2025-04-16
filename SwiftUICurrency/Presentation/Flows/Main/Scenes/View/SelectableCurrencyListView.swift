import SwiftUI

struct SelectableCurrencyListView: View {
    let currencies: [SelectableCurrency]
    let onToggle: (SelectableCurrency) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(currencies) { currency in
                    SelectableCurrencyRow(
                        currency: currency,
                        isSelected: currency.isSelected
                    )
                    .onTapGesture {
                        onToggle(currency)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
}
