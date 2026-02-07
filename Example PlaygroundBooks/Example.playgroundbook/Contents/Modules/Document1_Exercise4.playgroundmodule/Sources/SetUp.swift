//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world: GridWorld = loadGridWorld(named: "1.5")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: north, at: Coordinate(column: 3, row: 1))
    
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
    world.placeGems(at: [Coordinate(column: 2, row: 3)])
    world.place(nodeOfType: Switch.self, facing: north, at: [Coordinate(column: 1, row: 3)])
}
