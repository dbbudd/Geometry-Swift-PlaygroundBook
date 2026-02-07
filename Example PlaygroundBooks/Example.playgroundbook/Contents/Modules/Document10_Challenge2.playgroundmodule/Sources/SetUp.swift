//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "11.5")

public func playgroundPrologue() {
    placeItems()
    placeLocks()
    placeMissingStairs()
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

func placeMissingStairs() {
    world.place(Stair(), facing:  south, at: Coordinate(column: 7, row: 1))
    world.place(Stair(), facing: north, at: Coordinate(column: 7, row: 3))
}

func placeItems() {
    world.placeGems(at: [Coordinate(column: 4, row: 2)])
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 2, row: 2)])
}

func placeLocks() {
    let lock = PlatformLock(color: .pink)
    world.place(lock, facing: east, at: Coordinate(column: 0, row: 2))
    let lock1 = PlatformLock(color: .green)
    world.place(lock1, facing: west, at: Coordinate(column: 8, row: 2))
    let platform1 = Platform(onLevel: 1, controlledBy: lock1)
    world.place(platform1, at: Coordinate(column: 3, row: 2))
    let platform2 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 5, row: 2))

}

func placeStartMarker() {
    let expertMarker = StartMarker(type: .expert)
    let characterMarker = StartMarker(type: .byte)
    world.place(expertMarker, facing: north, at: Coordinate(column: 4, row: 0))
    world.place(characterMarker, facing: west, at: Coordinate(column: 6, row: 2))
}
