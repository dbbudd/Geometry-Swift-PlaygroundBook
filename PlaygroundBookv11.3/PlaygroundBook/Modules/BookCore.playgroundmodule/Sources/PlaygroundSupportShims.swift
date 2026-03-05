// Minimal shims to allow building without PlaygroundSupport on certain platforms
import Foundation
#if canImport(UIKit)
import UIKit
#endif

#if !canImport(PlaygroundSupport) || (arch(arm64) && targetEnvironment(simulator))
public enum PlaygroundValue {
    case integer(Int)
    case floatingPoint(Double)
    case string(String)
    case boolean(Bool)
    case data(Data)
    case array([PlaygroundValue])
    case dictionary([String: PlaygroundValue])
    case date(Date)
    case colorComponents(Double, Double, Double, Double)
    case resourcePath(String)
    case undefined
}

public protocol PlaygroundLiveViewMessageHandler: AnyObject {
    func receive(_ message: PlaygroundValue)
}

public protocol PlaygroundLiveViewSafeAreaContainer: AnyObject {}

public protocol PlaygroundLiveViewable {}

#if canImport(UIKit)
extension UIViewController: PlaygroundLiveViewable {}
extension UIView: PlaygroundLiveViewable {}
#endif
#endif

