//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world = loadGridWorld(named: "6.3")
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

func placeItems() {
    let items = [
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 1, row: 4),
                    Coordinate(column: 1, row: 5),
                    Coordinate(column: 1, row: 6),
                    Coordinate(column: 1, row: 7),
                    

                    
                    
                    
                    ]
    world.placeGems(at: items)
    
    let switches = [
        Coordinate(column: 3, row: 7),
        Coordinate(column: 3, row: 6),
        Coordinate(column: 3, row: 4),
        ]
    let openSwitch = Switch()
    openSwitch.isOn = true
    world.place(openSwitch, at: Coordinate(column: 2, row: 2))
    world.place(nodeOfType: Switch.self, at: switches)
}

func placeActor() {
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 0))
}


