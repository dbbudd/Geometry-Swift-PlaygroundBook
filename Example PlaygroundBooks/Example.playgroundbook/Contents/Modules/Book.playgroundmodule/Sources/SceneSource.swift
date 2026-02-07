//
//  SceneSource.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import SceneKit

// MARK: Proxy Classes

/*
 Proxy classes are used to substitute full unarchiving of SCN types.
 */

private class ProxyGeometry: SCNGeometry {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private class ProxyMaterial: SCNMaterial {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private class ProxyNode: SCNNode {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private class ProxyAnimation: CAAnimation {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private class ProxySkinner: SCNSkinner {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private class ProxyReferenceNode: SCNReferenceNode {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

extension SCNSceneSource {
    
    
    func entry(withID id: String) -> SCNNode? {
        guard let url = url, let data = try? Data(contentsOf: url, options: .alwaysMapped) else { return nil }
        
        do {
            let partialScene = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? SCNScene
            return partialScene?.rootNode.childNode(withName: id, recursively: true)
        }
        
        catch {
            return nil
        }
    }
}
