//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

//let world = GridWorld(columns: 5, rows: 9)
let world: GridWorld = loadGridWorld(named: "2.7")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: west, at: Coordinate(column: 2, row: 4))
    placeItems()
    

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
    let switchLocations = [
                              Coordinate(column: 0, row: 4),
                              Coordinate(column: 2, row: 0),
                              Coordinate(column: 2, row: 2),
                              Coordinate(column: 2, row: 6),
                              Coordinate(column: 2, row: 8),
                              Coordinate(column: 4, row: 4),
                              ]
    world.place(nodeOfType: Switch.self, at: switchLocations)
}
