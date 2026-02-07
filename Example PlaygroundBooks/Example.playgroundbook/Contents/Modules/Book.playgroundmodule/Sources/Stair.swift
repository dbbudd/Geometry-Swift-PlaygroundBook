//
//  Stair.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import SceneKit
import PlaygroundSupport

/**
 An instance of type `Stair` allows a character or expert to move up or down one unit of height in the puzzle world, using the `moveForward()` command.
 - localizationKey: Stair
 */
public final class Stair: Item, LocationConstructible, NodeConstructible {
    // MARK: Static
    
    static let template: SCNNode = {
        let node = Asset.node(named: "zon_stairs_a_half", in: .item(.stair), fileExtension: "scn")!
        node.position.y = -WorldConfiguration.levelHeight
        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .stair
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    public var isStackable: Bool {
        return true
    }
    
    public var verticalOffset: SCNFloat {
        return WorldConfiguration.levelHeight
    }
    
    // Only stairs which were initialized directly (not from an existing node) require geometry.
    let needsGeometry: Bool
    
    /// Creates a stair that can be placed in the world.
    ///
    /// - localizationKey: Stair()
    public init() {
        needsGeometry = true
        
        node = NodeWrapper(identifier: .stair)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .stair else { return nil }
        needsGeometry = false
        
        self.node = NodeWrapper(node)
    }
    
    // MARK: 
    
    public func loadGeometry() {
        guard needsGeometry && scnNode.childNodes.isEmpty else { return }
        scnNode.addChildNode(Stair.template.clone())
        
        if #available(iOS 13.0, *) {
            updateAppearance(traitCollection: UITraitCollection.current)
        }
    }
    
    public func updateAppearance(traitCollection: UITraitCollection) {
        guard #available(iOS 13.0, *) else { return }
        
        if let image = UIImage(named: "atlas_dark_DIFF") {
            for node in scnNode.childNodes {
                if let mat = node.firstGeometry?.firstMaterial {
                    mat.diffuse.contents = image
                }
            }
        }
    }
}

extension Stair: MessageConstructor {    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage)
    }
}

