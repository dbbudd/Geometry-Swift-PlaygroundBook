//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "10.4")
let actor = Actor()
public var greenPortal = Portal(color: .green)
public var orangePortal = Portal(color: .orange)

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
    world.place(actor, facing: south, at: Coordinate(column: 3, row: 4))
}

func placePortals() {
    world.place(greenPortal, between: Coordinate(column: 1, row: 1), and: Coordinate(column: 5, row: 4))
    world.place(orangePortal, between: Coordinate(column: 1, row: 4), and: Coordinate(column: 5, row: 1))
}

func placeItems() {
    let dzCoords = [
                       Coordinate(column: 1, row: 0),
                       Coordinate(column: 0, row: 1),
                       Coordinate(column: 1, row: 2),
                       Coordinate(column: 2, row: 1),
                       
                       Coordinate(column: 1, row: 5),
                       Coordinate(column: 0, row: 4),
                       
                       
                       ]
    world.place(nodeOfType: Switch.self, at: dzCoords)
    
    let itemCoords = [
                         Coordinate(column: 5, row: 0),
                         Coordinate(column: 4, row: 1),
                         Coordinate(column: 5, row: 2),
                         Coordinate(column: 6, row: 1),
                         
                         Coordinate(column: 5, row: 5),
                         Coordinate(column: 6, row: 4)
    ]
    world.placeGems(at: itemCoords)
}
