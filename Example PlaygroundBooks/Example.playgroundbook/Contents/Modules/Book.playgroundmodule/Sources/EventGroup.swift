//
//  EventGroup.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation

/// The different events (animation or audio) that an actor can perform.
/// These are top level identifiers for the asset variations (e.g. Walk, Walk02).
enum EventGroup: String {
    case `default`
    case idle, happyIdle
    case turnLeft, turnRight
    case pickUp
    case toggleSwitch
    
    case walk
    case walkUpStairs
    case walkDownStairs
    case run, runUpStairs, runDownStairs

    case jumpUp, jumpDown, jumpForward
    case teleport
    
    case turnLockLeft, turnLockRight
    
    case bumpIntoWall
    case almostFallOffEdge
    
    case defeat
    case victory, celebration
    
    case leave, arrive
    case pickerReactLeft, pickerReactRight
    
    /// The asset identifiers for every EventGroup.
    /// These identifiers correspond directly with asset names `(identifier).dae` and `(identifier).m4a`
    /// as described in Assets.swift.
    static var allIdentifiersByType: [EventGroup: [String]] {
        return [
            .default: ["BreathingIdle"],
            .happyIdle: ["HappyIdle"],
            .idle: ["Idle01", "Idle02", "Idle03", "BreatheLookAround"],
            .turnLeft: ["TurnLeft",],
            .turnRight: ["TurnRight",],
            .pickUp: ["GemTouch",],
            .toggleSwitch: ["Switch"],
            
            // Repeat "Walk" so that it is more likely in a random selection.
            .walk: ["Walk", "Walk", "Walk02"],
            .walkUpStairs: ["StairsUp", "StairsUp02"],
            .walkDownStairs: ["StairsDown", "StairsDown02"],
            .run: ["RunFast01", "RunFast02"],
            .runDownStairs: ["StairsDownFast"],
            .runUpStairs: ["StairsUpFast"],
            
            .jumpForward: ["Jump"],
            .jumpUp: ["JumpUp"],
            .jumpDown: ["JumpDown"],
            
            .teleport: ["Portal"],
            .turnLockLeft: ["LockPick01"],
            .turnLockRight: ["LockPick03"],
            
            .bumpIntoWall: ["BumpIntoWall",],
            .almostFallOffEdge: ["AlmostFallOffEdge",],
            
            .defeat: ["Defeat", "Defeat02", "HeadScratch"],
            .victory: ["Victory", "Victory02"],
            .celebration: ["CelebrationDance"],
            .leave: ["LeavePicker"],
            .arrive: ["ArrivePicker"],
            .pickerReactLeft: ["PickerReactLeft"],
            .pickerReactRight: ["PickerReactRight"],
        ]
    }
    
    public var description: String {
        switch self {
        case .idle:
            return NSLocalizedString("idle", comment: "AX description of idle EventGroup")
        case .happyIdle:
            return NSLocalizedString("happy idle", comment: "AX description of happyIdle EventGroup. Happy idle is an idling animation in which the character appears happy.")
        case .turnLeft:
            return NSLocalizedString("turn left", comment: "AX description of turnLeft EventGroup")
        case .turnRight:
            return NSLocalizedString("turn right", comment: "AX description of turnRight EventGroup")
        case .pickUp:
            return NSLocalizedString("pick up", comment: "AX description of pickUp EventGroup")
        case .toggleSwitch:
            return NSLocalizedString("toggle switch", comment: "AX description of toggleSwitch EventGroup")
        case .walk:
            return NSLocalizedString("walk", comment: "AX description of walk EventGroup")
        case .walkUpStairs:
            return NSLocalizedString("walk up stairs", comment: "AX description of walkUpStairs EventGroup")
        case .walkDownStairs:
            return NSLocalizedString("walk down stairs", comment: "AX description of walkDownStairs EventGroup")
        case .run:
            return NSLocalizedString("run", comment: "AX description of run EventGroup")
        case .runUpStairs:
            return NSLocalizedString("run up stairs", comment: "AX description of runUpStairs EventGroup")
        case .runDownStairs:
            return NSLocalizedString("run down stairs", comment: "AX description of runDownStairs EventGroup")
        case .jumpUp:
            return NSLocalizedString("jump up", comment: "AX description of JumpUp EventGroup")
        case .jumpDown:
            return NSLocalizedString("jump down", comment: "AX description of jumpDown EventGroup")
        case .jumpForward:
            return NSLocalizedString("jump forward", comment: "AX description of jumpForward EventGroup")
        case .teleport:
            return NSLocalizedString("teleport", comment: "AX description of teleport EventGroup")
        case .turnLockLeft:
            return NSLocalizedString("turn lock left", comment: "AX description of turnLockLeft EventGroup")
        case .turnLockRight:
            return NSLocalizedString("turn lock right", comment: "AX description of turnLockRight EventGroup")
        case .bumpIntoWall:
            return NSLocalizedString("bump into wall", comment: "AX description of bumpIntoWall EventGroup")
        case .almostFallOffEdge:
            return NSLocalizedString("almost fall off edge", comment: "AX description of almostFallOffEdge EventGroup")
        case .defeat:
            return NSLocalizedString("defeat", comment: "AX description of defeat EventGroup. Defeat is an animation that shows the character as sad because it has failed to complete the puzzle.")
        case .victory:
            return NSLocalizedString("victory", comment: "AX description of victory EventGroup. Victory is an animation that shows the character as happy because it has succesfully completed the puzzle.")
        case .celebration:
            return NSLocalizedString("celebration", comment: "AX description of celebration EventGroup")
        case .leave:
            return NSLocalizedString("leave", comment: "AX description of leave EventGroup")
        case .arrive:
            return NSLocalizedString("arrive", comment: "AX description of arrive EventGroup")
        case .pickerReactLeft:
            return NSLocalizedString("picker React Left", comment: "AX description of pickerReactLeft EventGroup")
        case .pickerReactRight:
            return NSLocalizedString("picker React Right", comment: "AX description of pickerReactRight EventGroup")
        default:
            return NSLocalizedString("default", comment: "AX description of default EventGroup")
        }
    }
    
    // MARK: Static Properties
    
    static var walkingAnimations: [EventGroup] {
        return [.walk, .walkUpStairs, .walkDownStairs, .turnLeft, .turnRight]
    }
    
    static func levelCompleteAnimations(for pass: Bool) -> [EventGroup] {
        if pass {
            return [.victory, .celebration, .happyIdle]
        }
        else {
            return [.defeat]
        }
    }
    
    // MARK: Properties
    
    var fastVariation: EventGroup? {
        switch self {
        case .walk: return .run
        case .walkUpStairs: return .runUpStairs
        case .walkDownStairs: return .runDownStairs
            
        default:
            return nil
        }
    }
    
    var isStationary: Bool {
        switch self {
        case .walk, .run,
             .walkUpStairs, .walkDownStairs,
             .runUpStairs, .runDownStairs,
             .turnLeft, .turnRight,
             .jumpUp, .jumpDown,
             .leave, .arrive,
             .teleport:
            
            return false
            
        default:
            return true
        }
    }
    
    var identifiers: [String] {
        return EventGroup.allIdentifiersByType[self] ?? []
    }
}

// MARK: EventVariation

struct EventVariation {
    var event: EventGroup
    var variationIndex: Int
    
    var identifier: String {
        guard let events = EventGroup.allIdentifiersByType[event],
            events.indices.contains(variationIndex) else { return "" }
        
        return events[variationIndex]
    }
}

extension EventVariation: Equatable {}
func ==(lhs: EventVariation, rhs: EventVariation) -> Bool {
    return lhs.event == rhs.event && lhs.variationIndex == rhs.variationIndex
}
