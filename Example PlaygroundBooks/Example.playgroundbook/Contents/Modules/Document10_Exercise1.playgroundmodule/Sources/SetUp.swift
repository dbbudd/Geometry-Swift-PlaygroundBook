//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "11.1")

public func playgroundPrologue() {
    placeItems()
    placeLocks()
    placeStartMarker()

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

// MARK: Placement

func placeItems() {
     world.placeGems(at: [Coordinate(column: 0, row: 3), Coordinate(column: 3, row: 0), Coordinate(column: 3, row: 6)])
}

func placeLocks() {
    
    let lock = PlatformLock()
    world.place(lock, facing: west, at: Coordinate(column: 7, row: 3))
    let platform1 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 3, row: 1))
    
}

func placeStartMarker() {
    let marker = StartMarker(type: .expert)
    world.place(marker, facing: .east, at: Coordinate(column: 3, row: 3))
}
