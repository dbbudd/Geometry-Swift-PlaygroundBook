import PlaygroundSupport

public func input<T: LosslessStringConvertible, U: LosslessStringConvertible>(_ value: U) -> T {
    let stringValue = String(value)

    if let view = PlaygroundPage.current.liveView as? GridPaperView {
        view.addInputField(defaultValue: stringValue)
    } else if let controller = PlaygroundPage.current.liveView as? LiveViewController {
        controller.gridPaper.addInputField(defaultValue: stringValue)
    }

    if T.self == String.self {
        return stringValue as! T
    }

    guard let converted = T(stringValue) else {
        fatalError("Unable to convert input value '\(stringValue)' to \(T.self).")
    }

    return converted
}
