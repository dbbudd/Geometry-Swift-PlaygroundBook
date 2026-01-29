import SwiftUI
import Book_Sources

@main
struct LiveViewTestAppApp: App {
    var body: some Scene {
        WindowGroup {
            LiveViewContainerView()
        }
    }
}

private struct LiveViewContainerView: View {
    var body: some View {
        LiveViewControllerRepresentable()
            .ignoresSafeArea()
    }
}

private struct LiveViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        Book_Sources.instantiateLiveViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
