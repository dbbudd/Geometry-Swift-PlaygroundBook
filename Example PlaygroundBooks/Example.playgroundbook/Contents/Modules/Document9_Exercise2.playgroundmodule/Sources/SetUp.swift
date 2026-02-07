//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "10.3")
public var bluePortal = Portal(color: .blue)
public var pinkPortal = Portal(color: .pink)
let actor = Actor()

public func playgroundPrologue() {
    // The state of portals should be announced by Voice Over.
    Accessibility.announcePortalStates = true

    placeActor()
    placeItems()
    placePortals()

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
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 1))
}

func placePortals() {
    world.place(bluePortal, between: Coordinate(column: 1, row: 2), and: Coordinate(column: 6, row: 3))
    world.place(pinkPortal, between: Coordinate(column: 1, row: 3), and: Coordinate(column: 4, row: 1))
}

func placeItems() {
    let itemCoordinates = [
                              Coordinate(column: 1, row: 4),
                              Coordinate(column: 4, row: 2),
                              Coordinate(column: 6, row: 2),
                              Coordinate(column: 6, row: 4),
                              
                              ]
    world.placeGems(at: itemCoordinates)
}
