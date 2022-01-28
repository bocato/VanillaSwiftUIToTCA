import SwiftUI

struct HomeScene: View {
    let onLogout: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Button(
                action: onLogout,
                label: {
                    Text("Logout")
                }
            )
            Spacer()
        }
    }
}
