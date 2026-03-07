import Foundation

@MainActor
public final class LiveViewInputStore {
    public static let shared = LiveViewInputStore()

    private var values: [String: PlaneInput] = [:]
    private var draggablePointValues: [String: (x: Double, y: Double)] = [:]
    private var observers: [() -> Void] = []

    private init() {}

    public func upsert(_ input: PlaneInput) {
        if values[input.id] == input {
            return
        }

        values[input.id] = input
        notifyObservers()
    }

    public func inputValue(for id: String) -> PlaneInput? {
        values[id]
    }

    public func decimalValue(for id: String) -> Double {
        values[id]?.decimalValue ?? 0
    }

    public func numberValue(for id: String) -> Int {
        values[id]?.numberValue ?? 0
    }

    public func textValue(for id: String) -> String {
        values[id]?.textValue ?? ""
    }

    public func addObserver(_ observer: @escaping () -> Void) {
        observers.append(observer)
    }

    public func upsertDraggablePoint(id: String, x: Double, y: Double) {
        if let existing = draggablePointValues[id], existing.x == x, existing.y == y {
            return
        }

        draggablePointValues[id] = (x: x, y: y)
        notifyObservers()
    }

    public func draggablePointValue(for id: String) -> (x: Double, y: Double)? {
        draggablePointValues[id]
    }

    private func notifyObservers() {
        observers.forEach { $0() }
    }
}
