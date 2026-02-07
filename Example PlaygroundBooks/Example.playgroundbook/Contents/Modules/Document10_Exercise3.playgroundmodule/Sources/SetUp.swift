//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "11.4")

public func playgroundPrologue() {
    placeItems()
    placePortals()
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

func placeItems() {
    world.placeGems(at: [Coordinate(column: 2, row: 1), Coordinate(column: 6, row: 1)])
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 1, row: 3), and: Coordinate(column: 6, row: 0))
}
    
func placeLocks() {
    
    let lock = PlatformLock()
    world.place(lock, facing: west, at: Coordinate(column: 4, row: 7))
    let platform1 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 1, row: 2))
    let platform2 = Platform(onLevel: 3, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 6, row: 1))
}

func placeStartMarker() {
    let expertMarker = StartMarker(type: .expert)
    let characterMarker = StartMarker(type: .byte)

    world.place(expertMarker, facing: east, at: Coordinate(column: 2, row: 7))
    world.place(characterMarker, facing: west, at: Coordinate(column: 3, row: 1))
}

