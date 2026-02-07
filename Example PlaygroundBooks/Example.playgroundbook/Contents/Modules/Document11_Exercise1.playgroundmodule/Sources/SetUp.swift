//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "12.5")

public func playgroundPrologue() {

    placeItems()
    placeStartMarker()

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
    //// ----
}

public func presentWorld() {
    setUpLiveViewWith(world)
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

// MARK: Placement

func placeItems() {
    world.placeGems(at: world.coordinates(inColumns: [4], intersectingRows: [0]))
    
    let lock = PlatformLock()
    world.place(lock, facing: west, at: Coordinate(column: 2, row: 1))
    let platform1 = Platform(onLevel: 2, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 2, row: 4))
    let platform2 = Platform(onLevel: 2, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 3, row: 4))
}

func placeStartMarker() {
    let expertMarker = StartMarker(type: .expert)
    world.place(expertMarker, facing: east, at: Coordinate(column: 0, row: 8))
}
