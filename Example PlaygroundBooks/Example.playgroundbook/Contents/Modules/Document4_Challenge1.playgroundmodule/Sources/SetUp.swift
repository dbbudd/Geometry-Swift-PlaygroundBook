//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world: GridWorld = loadGridWorld(named: "5.4")
public let actor = Actor()



public func playgroundPrologue() {

    placeItems()
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
    world.place(actor, facing: east, at: Coordinate(column: 1, row: 1))
}

func placeItems() {
    let items = [
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 4, row: 5),
                    Coordinate(column: 4, row: 1),
                    
                    ]
    world.placeGems(at: items)
}
