//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "10.1")
public var greenPortal = Portal(color: .green)

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
    world.place(actor, facing: north, at: Coordinate(column: 3, row: 0))
}

func placeItems() {
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 0, row: 3)])
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 3, row: 6)])
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 6, row: 3)])
}

func placePortals() {
    world.place(greenPortal, between: Coordinate(column: 3, row: 3), and: Coordinate(column: 5, row: 0))
}
