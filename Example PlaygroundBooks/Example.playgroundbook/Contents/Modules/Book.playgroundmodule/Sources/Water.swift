//
//  Water.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import SceneKit
import PlaygroundSupport

/**
 All instances of water blocks are of type 'Water'. Water can be placed only at a coordinate where all existing blocks have been removed.
 - localizationKey: Water
 */
public final class Water: Item, LocationConstructible, NodeConstructible {
    // MARK: Static
    
    static let template = Asset.node(named: "zon_barrier_water_1x1_with_geo", in: .item(.water), fileExtension: "scn")!
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .water
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    public var isStackable: Bool {
        return true
    }
    
    // Only Water which was initialized directly (not from an existing node) require geometry.
    let needsGeometry: Bool

    /// Creates a water block that can be placed in the world.
    ///
    /// - localizationKey: Water()
    public init() {
        needsGeometry = true
        node = NodeWrapper(identifier: .water)
    }
    
    init?(node: SCNNode) {
        // Support maps exported with blocks named "Obstacle".
        guard node.identifier == .water
            || node.identifierComponents.first == "Obstacle" else { return nil }
        needsGeometry = false
        self.node = NodeWrapper(node)
    }
    
    public func loadGeometry() {
        guard needsGeometry, scnNode.childNodes.isEmpty else { return }
        scnNode.addChildNode(Water.template.clone())
        
        if #available(iOS 13.0, *) {
            updateAppearance(traitCollection: UITraitCollection.current)
        }
    }
    
    public func updateAppearance(traitCollection: UITraitCollection) {
        guard #available(iOS 13.0, *) else { return }
        
        if let image = UIImage(named: "zon_barrier_a_water_dark_DIFF") {
            for node in scnNode.childNodes {
                if let mat = node.firstGeometry?.firstMaterial {
                    mat.diffuse.contents = image
                }
            }
        }
    }
}

extension Water: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage)
    }
}

