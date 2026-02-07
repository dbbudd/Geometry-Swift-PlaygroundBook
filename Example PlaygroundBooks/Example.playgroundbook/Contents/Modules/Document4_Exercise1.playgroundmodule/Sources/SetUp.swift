//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world = loadGridWorld(named: "5.1")
public let actor = Actor()

let switchCoordinates = [
    Coordinate(column: 0, row: 2),
    Coordinate(column: 1, row: 2),
    Coordinate(column: 2, row: 2)
]

public func playgroundPrologue() {
    
    placeActor()
    placeRandomNodes()

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomItems()
    }
    //// ----
}

// Called from LiveView.swift to initially set the LiveView.
public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

func placeActor() {
    world.place(actor, facing: west, at: Coordinate(column: 4, row: 2))
}

func placeRandomNodes() {
    let switchItem = Switch()
    
    for coord in switchCoordinates {
        world.place(RandomNode(resembling: switchItem), at: coord)
    }
}

func realizeRandomItems() {
    let switchNodes = world.place(nodeOfType: Switch.self, at: switchCoordinates)
    
    for switchNode in switchNodes {
        switchNode.isOn = randomBool()
    }
    
    // Ensure at least one Switch is off.
    let switchNode = switchNodes.randomElement
    switchNode?.isOn = false
}
