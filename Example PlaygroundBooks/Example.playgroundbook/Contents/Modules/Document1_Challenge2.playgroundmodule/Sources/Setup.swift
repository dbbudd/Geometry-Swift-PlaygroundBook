//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

//let world = GridWorld(columns: 5, rows: 7)
let world: GridWorld = loadGridWorld(named: "1.6")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: north, at: Coordinate(column: 4, row: 2))
    
    placeItems()
    placePortals()

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
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

func placeItems() {
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 2, row: 3)])
    world.placeGems(at: [Coordinate(column: 1, row: 6)])
    
    let switchNodes = world.place(nodeOfType: Switch.self, at: [Coordinate(column: 4, row: 5)])
    for switchNode in switchNodes {
        switchNode.isOn = true
    }
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 0, row: 3), and: Coordinate(column: 3, row: 6))
}
