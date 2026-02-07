//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
//let world = GridWorld(columns: 8, rows: 7)
let world: GridWorld = loadGridWorld(named: "1.4")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: north, at: Coordinate(column: 5, row: 0))
    
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
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 3, row: 3)])
    world.placeGems(at: [Coordinate(column: 0, row: 4)])
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 2, row: 3), and: Coordinate(column: 1, row: 6))
}
