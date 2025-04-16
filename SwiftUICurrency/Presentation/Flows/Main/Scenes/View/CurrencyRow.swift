import SwiftUI

struct CurrencyRow: View {
    let item: ExchangeRate.CurrencyRate

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.05))
                    .frame(width: 44, height: 44)

                Text(item.target.flagEmoji)
                    .font(.title2)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("\(item.source) / \(item.target)")
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.4f", item.rate))
                    .font(.headline)
                    .foregroundColor(.black)

                if let diff = item.diff {
                    Text(String(format: "%+.4f", diff))
                        .font(.caption)
                        .foregroundColor(diff >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

extension ExchangeRate.CurrencyRate {
    var target: String {
        String(pair.suffix(3))
    }
    
    var source: String {
        String(pair.prefix(3))
    }
}

