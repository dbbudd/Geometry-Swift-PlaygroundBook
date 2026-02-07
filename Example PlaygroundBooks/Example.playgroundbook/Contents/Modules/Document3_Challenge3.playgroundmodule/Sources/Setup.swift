//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import SceneKit
import PlaygroundSupport
import Book

// MARK: Globals
let world = loadGridWorld(named: "4.1")
let actor = Actor()

public func playgroundPrologue() {

    placeActor()
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

func placeActor() {
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 0))
}

func placeItems() {
    let items = [
                    Coordinate(column: 8, row: 2),
                    Coordinate(column: 8, row: 4),
                    Coordinate(column: 8, row: 6),
                    
                    
                    ]
    world.place(nodeOfType: Switch.self, at: items)
}
