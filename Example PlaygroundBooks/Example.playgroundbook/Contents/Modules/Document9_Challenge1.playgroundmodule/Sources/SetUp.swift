//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "10.2")
let actor = Actor()

public var purplePortal = Portal(color: .purple)

public func playgroundPrologue() {
    // The state of portals should be announced by Voice Over.
    Accessibility.announcePortalStates = true

    placeItems()
    placeActor()
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

func placeItems() {
    world.place(Switch(), at: Coordinate(column: 0, row: 1))
    world.placeGems(at: world.coordinates(inColumns: [3,4,5], intersectingRows: [1]))
    world.placeGems(at: world.coordinates(inColumns: [3,4,5,6], intersectingRows: [4]))
}

func placePortals() {
    world.place(purplePortal, between: Coordinate(column: 2, row: 4), and: Coordinate(column: 2, row: 1))
}

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column:0, row: 4))
}
