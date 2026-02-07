//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

//let world = GridWorld(columns: 6, rows: 6)
let world: GridWorld = loadGridWorld(named: "2.4")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: east, at: Coordinate(column: 1, row: 4))
    placeItems()
    placeAdditionalBlocks()
    

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
                    Coordinate(column: 1, row: 4),
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 3, row: 4),
                    
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 3, row: 3),
                    
                    Coordinate(column: 1, row: 2),
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 3, row: 2),
                    
                    ]
    world.placeGems(at: items)
    
}

func placeAdditionalBlocks() {
    let tiers = [
        Coordinate(column: 4, row: 4),
        Coordinate(column: 4, row: 3),
        Coordinate(column: 4, row: 2),
        
        Coordinate(column: 4, row: 1),
        Coordinate(column: 3, row: 1),
        Coordinate(column: 2, row: 1),
        Coordinate(column: 1, row: 1),


        ]
    world.placeBlocks(at: tiers)

}
