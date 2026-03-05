import PlaygroundSupport

@MainActor
public final class LiveViewMessageRouter {
    public static let shared = LiveViewMessageRouter()

    public var handler: ((PlaygroundValue) -> Void)? {
        didSet {
            guard let handler else { return }
            let queued = pendingMessages
            pendingMessages.removeAll()
            queued.forEach(handler)
        }
    }

    private var pendingMessages: [PlaygroundValue] = []

    private init() {}

    public func send(_ message: PlaygroundValue) {
        if let handler {
            handler(message)
        } else {
            pendingMessages.append(message)
        }
    }
}
