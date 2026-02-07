//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
//let world = GridWorld(columns: 6, rows: 6)
let world: GridWorld = loadGridWorld(named: "2.1")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: west, at: Coordinate(column: 4, row: 1))
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
    world.placeGems(at: [Coordinate(column: 1, row: 4)])
}
