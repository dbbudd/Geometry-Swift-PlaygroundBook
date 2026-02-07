//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world: GridWorld = loadGridWorld(named: "3.4")
let actor = Actor()

public func playgroundPrologue() {
    
    placeItems()
    placePortals()
    placeActor()
    

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

func placeActor() {
    world.place(actor, facing: south, at: Coordinate(column: 0, row: 3))
}

func placeItems() {
    let items = [
                    Coordinate(column: 1, row: 0),
                    Coordinate(column: 2, row: 2),
                    
                    Coordinate(column: 4, row: 1),
                    Coordinate(column: 4, row: 4),
                    
                    Coordinate(column: 6, row: 3),
                    
                    
                    
                    ]
    world.placeGems(at: items)
}

func placePortals() {
    world.place(Portal(color: .pink), between: Coordinate(column: 0, row: 0), and: Coordinate(column: 7, row: 2))
    world.place(Portal(color: .green), between: Coordinate(column: 2, row: 4), and: Coordinate(column: 4, row: 0))
}
