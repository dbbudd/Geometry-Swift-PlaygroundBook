import UIKit
import PlaygroundSupport

let viewController = GridViewController()

public func _setup() {
    PlaygroundPage.current.liveView = viewController
}

func addShape(pen: Pen){
    viewController.addChild(pen)
}
