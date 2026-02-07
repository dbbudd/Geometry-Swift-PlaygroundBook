//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

//let world = GridWorld(columns: 9, rows: 6)
let world: GridWorld = loadGridWorld(named: "1.7")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: east, at: Coordinate(column: 3, row: 0))
    
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
    world.placeGems(at: [Coordinate(column: 6, row: 0)])
    world.place(nodeOfType: Switch.self, facing: east, at: [Coordinate(column: 4, row: 5)])
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 1, row: 2), and: Coordinate(column: 7, row: 5))
    world.place(Portal(color: .green), between: Coordinate(column: 2, row: 5), and: Coordinate(column: 8, row: 0))
}
