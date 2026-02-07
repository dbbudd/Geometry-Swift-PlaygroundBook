//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world: GridWorld = loadGridWorld(named: "1.3")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: west, at: Coordinate(column: 2, row: 5))
    
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
    world.place(Switch(), facing: west, at: Coordinate(column: 2, row: 3))
    world.place(Gem(), at: Coordinate(column: 0, row: 4))
}
