//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world = loadGridWorld(named: "5.7")
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
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 0))
}

func placeItems() {
    let itemCoordinates = [
                              Coordinate(column: 0, row: 5),
                              Coordinate(column: 0, row: 2),
                              Coordinate(column: 1, row: 4),
                              Coordinate(column: 1, row: 1),
                              Coordinate(column: 4, row: 5),
                              Coordinate(column: 4, row: 2)
    ]
    world.placeGems(at: itemCoordinates)
    
    let dz = [
                 Coordinate(column: 1, row: 5),
                 Coordinate(column: 1, row: 2)
    ]    
    let switchNodes = world.place(nodeOfType: Switch.self, at: dz)
    
    for switchNode in switchNodes {
        switchNode.isOn = false
    }
    
    let switchNode = Switch()
    world.place(switchNode, at: Coordinate(column: 1, row: 3))
    switchNode.isOn = true
}
