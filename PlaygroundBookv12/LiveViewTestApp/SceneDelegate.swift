import UIKit
import PlaygroundSupport
import BookCore

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let liveView = makeLiveView()
        window.rootViewController = rootViewController(for: liveView)
        window.makeKeyAndVisible()

        self.window = window
    }

    private func makeLiveView() -> PlaygroundLiveViewable {
        let liveView = BookCore.instantiateLiveView()

        if let liveViewController = liveView as? LiveViewController {
            DebugLiveViewContent.render(on: liveViewController)
        }

        return liveView
    }

    private func rootViewController(for liveView: PlaygroundLiveViewable) -> UIViewController {
        if let viewController = liveView as? UIViewController {
            return viewController
        }

        if let view = liveView as? UIView {
            let viewController = UIViewController()
            view.translatesAutoresizingMaskIntoConstraints = false
            viewController.view.addSubview(view)

            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
                view.topAnchor.constraint(equalTo: viewController.view.topAnchor),
                view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
            ])

            return viewController
        }

        return UIViewController()
    }
}
