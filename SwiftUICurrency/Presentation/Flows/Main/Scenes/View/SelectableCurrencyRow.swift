import SwiftUI

struct SelectableCurrencyRow: View {
    let currency: SelectableCurrency
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.05))
                    .frame(width: 44, height: 44)

                Text(currency.target.flagEmoji)
                    .font(.title2)
            }

            Text("\(currency.source) / \(currency.target)")
                .font(.headline)
                .foregroundColor(.black)

            Spacer()

            Circle()
                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1.5)
                .background(
                    Circle().fill(isSelected ? Color.orange : Color.clear)
                )
                .frame(width: 24, height: 24)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

