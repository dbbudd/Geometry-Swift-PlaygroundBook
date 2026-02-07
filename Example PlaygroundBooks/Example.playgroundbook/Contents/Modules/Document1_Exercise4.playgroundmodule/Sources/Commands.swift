//
//  Commands.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Book

/// Turns the character left.
///
/// - localizationKey: Commands.turnLeft()
public func turnLeft() {
    actor.turnLeft()
}


/// Moves the character forward one tile.
///
/// - localizationKey: Commands.moveForward()
public func moveForward() {
    actor.moveForward()
}

/// Instructs the character to toggle a switch on the current tile.
///
/// - localizationKey: Commands.toggleSwitch()
public func toggleSwitch() {
    actor.toggleSwitch()
}

/// Instructs the character to collect a gem on the current tile.
///
/// - localizationKey: Commands.collectGem()
public func collectGem() {
    actor.collectGem()
}

/// Condition that checks if the character is on a tile with an open switch on it.
///
/// - localizationKey: Commands.isOnOpenSwitch
public var isOnOpenSwitch: Bool {
    return actor.isOnOpenSwitch
}

/// Condition that checks if the character is on a tile with a closed switch on it.
///
/// - localizationKey: Commands.isOnClosedSwitch
public var isOnClosedSwitch: Bool {
    return actor.isOnClosedSwitch
}

/// Condition that checks if the character is on a tile with a gem on it.
///
/// - localizationKey: Commands.isOnGem
public var isOnGem: Bool {
    return actor.isOnGem
}

/// Condition that checks if the character is blocked from moving forward in the current direction.
///
/// - localizationKey: Commands.isBlocked
public var isBlocked: Bool {
    return actor.isBlocked
}

/// Condition that checks if the character is blocked on the right.
///
/// - localizationKey: Commands.isBlockedRight
public var isBlockedRight: Bool {
    return actor.isBlockedRight
}

/// Condition that checks if the character is blocked on the left.
///
/// - localizationKey: Commands.isBlockedLeft
public var isBlockedLeft: Bool {
    return actor.isBlockedLeft
}

/// Instructs the character to jump up or down onto the block the character is facing.
/// If the current tile and the tile the character is facing are the same height, the character simply jumps forward one tile.
///
/// - localizationKey: Commands.jump()
public func jump() {
    actor.jump()
}
