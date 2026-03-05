import Foundation
#if canImport(UIKit)
import UIKit
#endif

#if !canImport(LiveViewHost)
public enum LiveViewHost {
    public enum LiveViewConfiguration {
        case fullScreen
        case sideBySide
    }

    open class AppDelegate: UIResponder, UIApplicationDelegate {
        public var window: UIWindow?

        open func setUpLiveView() -> PlaygroundLiveViewable {
            fatalError("Override setUpLiveView() in your AppDelegate to return a view or view controller")
        }

        open var liveViewConfiguration: LiveViewConfiguration { .fullScreen }

        public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            #if canImport(UIKit)
            let window = UIWindow(frame: UIScreen.main.bounds)
            let live = setUpLiveView()
            if let vc = live as? UIViewController {
                window.rootViewController = vc
            } else if let view = live as? UIView {
                let vc = UIViewController()
                vc.view = view
                window.rootViewController = vc
            } else {
                let vc = UIViewController()
                vc.view.backgroundColor = .white
                window.rootViewController = vc
            }
            self.window = window
            window.makeKeyAndVisible()
            #endif
            return true
        }
    }
}
#endif
