import SwiftUI

struct LastUpdatedView: View {
    let text: String

    var body: some View {
        HStack {
            Text("Last Updated: \(text)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
        }
        .padding(.horizontal)
    }
}
