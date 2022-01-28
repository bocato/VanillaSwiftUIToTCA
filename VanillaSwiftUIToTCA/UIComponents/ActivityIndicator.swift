import SwiftUI

// SwiftUI doesn't have a view for activity indicators, so we make `UIActivityIndicatorView` accessible from SwiftUI.
struct ActivityIndicator: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style = .large

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
         uiView.startAnimating()
    }
}
