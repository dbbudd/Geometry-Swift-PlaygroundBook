//
//  ActorType.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import SceneKit

/// An enum used to group all the characters.
public enum ActorType: String {
    case byte
    case blu
    case hopper
    case expert
    case octet
    
    static var cases: [ActorType] = [
        .byte, .blu, .hopper, .expert, .octet
    ]
    
    var color: Color {
        switch self {
        case .byte, .octet: return .orange
        case .blu: return .blue
        case .hopper: return .green
        case .expert: return .red
        }
    }
    
    var description: String {
        switch self {
        case .byte, .octet:
            let formatDesc = NSLocalizedString("%@ is orange, with two arms and two legs, and a small green periscope-like head, in the middle of which is an eye. %@ carries a yellow waist pack.", comment: "Description of Byte/Octet")
            return String(format: formatDesc, name(), name())
        case .blu:
            let formatDesc = NSLocalizedString("%@ is blue, and shaped like a water droplet, with one eye, a mouth, two arms and two legs. %@ carries a brown shoulder bag.", comment: "Description of Blu")
            return String(format: formatDesc, name(), name())
        case .hopper:
            let formatDesc = NSLocalizedString("%@ is green, wears a pink waistcoat, and has a head like a hammerhead shark, in which are two eyes and a mouth. %@ has two arms and two legs, and carries a white backpack.", comment: "Description of Hopper")
            return String(format: formatDesc, name(), name())
        case .expert:
            let formatDesc = NSLocalizedString("%@ is red, and has a head with three bumps on top. %@ has one eye, a mouth, two arms, and tiny legs, and carries a heavy-looking computer backpack.", comment: "Description of Expert")
            return String(format: formatDesc, name(), name())
        }
    }
    
    var directory: Asset.Directory {
        return .actor(self)
    }
    
    func sounds(for group: EventGroup) -> [SCNAudioSource] {
        return Asset.sounds(for: group, in: directory)
    }
    
    func animations(for group: EventGroup) -> [CAAnimation] {
        return Asset.animations(for: group, in: directory)
    }
    
    func createNode() -> SCNNode {
        // Attempt to find the actor’s 'NeutralPose' as a "dae", fallback to look for "scn".
        guard let node = Asset.neutralPose(in: directory) ?? Asset.neutralPose(in: directory, fileExtension: "scn") else {
            fatalError("Could not load 'NeutralPose' from: \(directory.path).")
        }
        
        // Configure the node. 
        node.enumerateChildNodes { child, _ in
            child.castsShadow = true
            child.categoryBitMask = WorldConfiguration.shadowBitMask
        }

        return node
    }
    
    func resourceStub() -> String {
        switch self {
        case .byte, .octet:
            return ActorType.byte.rawValue.uppercased()
        default:
            return self.rawValue.uppercased()
            
        }
    }
    
    func name() -> String {
        if self == .byte, let languageCode = Locale.autoupdatingCurrent.languageCode, languageCode == "fr" {
            return ActorType.octet.rawValue
        }

        return self.rawValue
    }
}
