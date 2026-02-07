//
//  Setup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world: GridWorld = loadGridWorld(named: "3.3")
let actor = Actor()

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
    world.place(actor, facing: north, at: Coordinate(column: 2, row: 2))
}

func placeItems() {
    let items = [
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 4, row: 2),
                    
                    Coordinate(column: 2, row: 0),
                    Coordinate(column: 2, row: 4),
                    
                    
                    ]
    world.place(nodeOfType: Switch.self, at: items)
    
    
    let switches = [
                       Coordinate(column: 4, row: 4),
                       Coordinate(column: 0, row: 0),
                       Coordinate(column: 4, row: 0),
                       Coordinate(column: 0, row: 4),
                       
                       ]
    
    let switchNodes = world.place(nodeOfType: Switch.self, at: switches)
    
    for switchNode in switchNodes {
        
        switchNode.isOn = true
        
    }
}
