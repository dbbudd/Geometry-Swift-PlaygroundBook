//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "12.1")


public func playgroundPrologue() {

    placePlatforms()
    placeStair()
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
    world.placeGems(at: world.coordinates(inColumns: [4], intersectingRows: [5]))
    world.placeGems(at: world.coordinates(inColumns: [5], intersectingRows: [0,6]))
    world.placeGems(at: world.coordinates(inColumns: [6], intersectingRows: [1,5]))
    world.placeGems(at: world.coordinates(inColumns: [7], intersectingRows: [2,4]))
}

func placePlatforms() {
    let lock = PlatformLock(color: .blue)
    world.place(lock, facing: east, at: Coordinate(column: 0, row: 6))
    let lock2 = PlatformLock(color: .orange)
    world.place(lock2, facing: north, at: Coordinate(column: 1, row: 5))
    let lock3 = PlatformLock(color: .green)
    world.place(lock3, facing: south, at: Coordinate(column: 1, row: 7))
    let lock4 = PlatformLock(color: .pink)
    world.place(lock4, facing: west, at: Coordinate(column: 2, row: 6))
    
    
    let platform1 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 5, row: 1))
    let platform2 = Platform(onLevel: 1, controlledBy: lock2)
    world.place(platform2, at: Coordinate(column: 6, row: 2))
    let platform3 = Platform(onLevel: 1, controlledBy: lock3)
    world.place(platform3, at: Coordinate(column: 5, row: 5))
    let platform4 = Platform(onLevel: 1, controlledBy: lock4)
    world.place(platform4, at: Coordinate(column: 6, row: 4))
}

func placeStair() {
    world.place(Stair(), facing: south, at: Coordinate(column: 4, row: 4))
}

func placeStartMarker() {
    let expertMarker = StartMarker(type: .expert)
    let chararacterMarker = StartMarker(type: .byte)

    world.place(expertMarker, facing: north, at: Coordinate(column: 1, row: 6))
    world.place(chararacterMarker, facing: north, at: Coordinate(column: 4, row: 3))
}
