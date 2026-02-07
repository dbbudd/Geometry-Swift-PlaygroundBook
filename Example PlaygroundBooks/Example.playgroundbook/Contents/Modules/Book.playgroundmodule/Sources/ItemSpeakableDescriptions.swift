//
//  ItemSpeakableDescriptions.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation

// MARK: DescriptionComponents

struct ItemDescriptionComponents: OptionSet {
    let rawValue: Int
    
    static let name  = ItemDescriptionComponents(rawValue: 1 << 0)
    static let height  = ItemDescriptionComponents(rawValue: 1 << 1)
    static let direction  = ItemDescriptionComponents(rawValue: 1 << 2)
}

extension Item {
    
    var locationDescription: String{
        return "\(coordinate.description)"
    }
    
    func description(with components: ItemDescriptionComponents) -> String {
        var description = ""

        func _getName() -> String {
            if components.contains(.name) {
                switch identifier {
                case .block:
                    return NSLocalizedString("block", comment: "The localized name for a block")

                case .stair:
                    return NSLocalizedString("stair", comment: "The localized name for a stair")

                case .wall:
                    return NSLocalizedString("wall", comment: "The localized name for a wall")

                case .water:
                    return NSLocalizedString("water", comment: "The localized name for water")

                case .gem:
                    return NSLocalizedString("gem", comment: "The localized name for a gem")

                case .switch:
                    return NSLocalizedString("switch", comment: "The localized name for a switch")

                case .platformLock:
                    return NSLocalizedString("platform lock", comment: "The localized name for a platform lock")

                case .platform:
                    return NSLocalizedString("platform", comment: "The localized name for a platform")

                case .startMarker:
                    return NSLocalizedString("start marker", comment: "The localized name for a start marker")

                case .randomNode:
                    return NSLocalizedString("random node", comment: "The localized name for a random node")

                case .actor:
                    return NSLocalizedString("actor", comment: "The localized name for an actor")

                case .portal:
                    if Accessibility.announcePortalStates {
                        if let portal = self as? Portal, let type = portal.shape?.axDescription, portal.isActive {
                            return String(format: NSLocalizedString("active %@", comment: "The localized name for an active portal"), type)
                        }
                        else {
                            let desc = ""
                            if let portal = self as? Portal, let type = portal.shape?.axDescription {
                                return String(format: NSLocalizedString("inactive %@", comment: "The localized name for an inactive portal"), type)
                            }
                            return desc
                        }
                    }
                    else {
                        var desc = ""
                        if let portal = self as? Portal, let type = portal.shape?.axDescription {
                            desc = String(format: "%@", type)
                        }
                        return desc
                    }
                }
            }
            else {
                return ""
            }
        }

        if components.contains(.height) && components.contains(.direction) {
            let direction = heading.description
            description = String(format: NSLocalizedString("%@ at height %d facing %@", comment: "AX item description. 'height' is number of blocks from the ground a thing is. 'direction' is a heading (north, south, east, west)"), _getName(), height, direction)
        }
        else if components.contains(.height) {
            description = String(format: NSLocalizedString("%@ at height %d", comment: "AX item description. Height is number of blocks from the ground a thing is."), _getName(), height)
        }
        else if components.contains(.direction) {
            let direction = heading.description
            description = String(format: NSLocalizedString("%@ facing %@", comment: "AX item description. 'direction' is a heading (north, south, east, west)"), _getName(), direction)
        }
        else if components.contains(.name) {
            description = _getName()
        }

        return description
    }
}

// MARK: Speakable Descriptions

extension Actor {
    var speakableName: String {
        return type.name()
    }
    
    public var speakableCharacterDescription: String {
        return type.description
    }
    
    public var speakableDescription: String {
        let desc = description(with: [.height, .direction])
        return "\(speakableName) \(desc)"
    }
    
    /// Forms a speakable description for Actor commands.
    func speakableDescription(for action: Action) -> String {
        switch action {
        case let .move(displace, type):
            let to = displace.to
            let from = displace.from
            let typeDesc = type.speakableDescription
            
            let description: String
            if from.y.isClose(to: to.y) {
                description = String(format: NSLocalizedString("%@ to %@", comment: "AX move action description. Movement type {walk, jump, teleport} to coordinate location {column, row}"), typeDesc, Coordinate(to).description)
            }
            else {
                let ascending = from.y < to.y
                let newHeight = height + (ascending ? 1 : -1)
                if ascending == true {
                    description = String(format: NSLocalizedString("%@ up to height %d %@", comment: "AX move action description. Movement type {walk, jump, teleport} to height {number of blocks above the ground} coordinate location {column, row}"), typeDesc, newHeight, Coordinate(to).description)
                }
                else {
                    description = String(format: NSLocalizedString("%@ down to height %d %@", comment: ""), typeDesc, newHeight, Coordinate(to).description)
                }
            }
            
            return description
            
        case let .turn(displace, clkwise):
            let facingDirection = Direction(radians: displace.to).description
            let description: String
            
            if clkwise == true {
                description = String(format: NSLocalizedString("turned right, now facing %@", comment: "AX actor action description. 'facing' is a heading (north, south, east, west)"), facingDirection)
            }
            else {
                description = String(format: NSLocalizedString("turned left, now facing %@", comment: "AX actor action description. 'facing' is a heading (north, south, east, west)"), facingDirection)
            }
            
            return description
            
        case .add(let ids):
            guard let world = world, !ids.isEmpty else { return "" }
            let item = world.item(forID: ids[0])!
            
            return String(format: NSLocalizedString("placed node at %@", comment: "AX actor action description. 'at' is a coordinate {row x, column y}"), item.coordinate.description)
            
        case .remove(let ids):
            guard let world = world, !ids.isEmpty else { return "" }
            let item = world.item(forID: ids[0])!
            
            return String(format: NSLocalizedString("collected gem at %@", comment: "AX actor action description. 'at' is a coordinate {row x, column y}"), item.coordinate.description)
            
        case .control(let contr):
            return contr.speakableDescription
            
        case let .run(type):
            let animation = type.0.description
            return String(format: NSLocalizedString("playing %@ animation", comment: "AX actor action description. 'animation' is a simple description of what's happening to the character in the scene. e.g., walk, jump, bumpIntoWall"), animation)
            
        case let .fail(command):
            return command.speakableDescription
        }
    }
}

extension Stair {
    public var speakableDescription: String {
        let heightDesc: String
        
        let neighbor = coordinate.neighbor(inDirection: heading)
        if neighbor.column == coordinate.column {
            heightDesc = String(format: NSLocalizedString("stairs, leading to height %d, from row %d", comment: "AX stairs description."), height, neighbor.row)
        }
        else {
            heightDesc = String(format: NSLocalizedString("stairs, leading to height %d, from column %d", comment: "AX stairs description."), height, neighbor.column)
        }
        return heightDesc
    }
}

extension Switch {
    public var speakableDescription: String {
        if isOn == true {
            return String(format: NSLocalizedString("open %@", comment: "AX switch description. 'open' means 'not sealed'"), description(with: [.name, .height]))
        }
        else {
            return String(format: NSLocalizedString("closed %@", comment: "AX switch description. 'closed' means 'sealed'"), description(with: [.name, .height]))
        }
    }
}

extension Portal {
    public var speakableDescription: String {
        var desc = axDescription
        if desc.isEmpty {
             desc += description(with: [.name, .height])
        }
        else {
            desc += description(with: [.height])
        }
        if let connected = linkedPortal {
            desc = String(format: NSLocalizedString("%@ connected to %@ %@", comment: "AX portal description. Portals are linked to other portals. This is describing the location of the other end of the connection. Reads as: '{portal n}' connected to '{row x column y}' 'height of connected portal'"), desc, connected.coordinate.description, connected.description(with: [.height]))
        }
        return desc
    }
}

extension Wall {
    public var speakableDescription: String {
        var desc = description(with: [.name, .height])
        for neighbor in coordinate.neighbors
            where blocksMovement(from: coordinate, to: neighbor) {
                desc += String(format: NSLocalizedString(" blocking movement to %@", comment: "AX wall description. Subject is dynamically generated. 'movement to' is a coordinate. Read as: [wall at height] blocking movement to {column, row}"), neighbor.description) + ","
        }
        return desc
    }
}

extension Water {
    public var speakableDescription: String {
        return description(with: [.name])
    }
}

extension StartMarker {
    public var speakableDescription: String {
        return description(with: [.name, .height, .direction])
    }
}

extension Block {
    public var speakableDescription: String {
        return description(with: [.name, .height])
    }
}

extension Platform {
    public var speakableDescription: String {
        return description(with: [.name, .height])
    }
}

extension RandomNode {
    public var speakableDescription: String {
        return String(format: NSLocalizedString("random %@ marker", comment: "AX random node description."), resemblingNode.description(with: [.name]))
    }
}

extension Gem {
    public var speakableDescription: String {
        return description(with: [.name, .height])
    }
}

extension PlatformLock {
    public var speakableDescription: String {
        let baseInfo = description(with: [.name, .height])
        
        let platformsDesc = platforms.reduce("") { result, platform in
            return result + platform.speakableDescription
        }
        
        let controllingDesc = platformsDesc.isEmpty ? "" : String(format: NSLocalizedString(" Controlling %@", comment: "AX platform lock description."), platformsDesc)
        
        return baseInfo + controllingDesc
    }
}
