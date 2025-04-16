import SwiftUI

struct MainSceneHeaderView: View {
    let onAddTapped: () -> Void

    var body: some View {
        HStack {
            Text("My Currencies")
                .font(.largeTitle)
                .foregroundColor(.white)
            Spacer()
            Button(action: onAddTapped) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }
}
