import SwiftUI

struct SelectCurrencyHeaderView: View {
    @Binding var searchText: String

    var body: some View {
        VStack(spacing: 12) {
            Text("Choose currency")
                .font(.title)
                .foregroundColor(.white)

            TextField("Search currency", text: $searchText)
                .padding(10)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
                .foregroundColor(.white)
        }
    }
}
