//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

//let world = GridWorld(columns: 7, rows: 5)
let world = loadGridWorld(named: "2.6")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 2))
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
    
    let items = [
                    Coordinate(column: 1, row: 0),
                    Coordinate(column: 2, row: 0),
                    Coordinate(column: 3, row: 0),
                    
                    Coordinate(column: 1, row: 4),
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 3, row: 4),
                    
                    
                    ]
    world.placeGems(at: items)
}
