//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

//let world = GridWorld(columns: 5, rows: 5)
let world: GridWorld = loadGridWorld(named: "2.5")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 1))
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
    let gems = [
                   Coordinate(column: 0, row: 1),
                   Coordinate(column: 1, row: 0),
                   Coordinate(column: 1, row: 2),
                   Coordinate(column: 2, row: 1),
                   
                   ]
    
    world.placeGems(at: gems)
}
