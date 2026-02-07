//
//  AccessibilityExtensions.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import UIKit
import SceneKit

/// Describes the contents of each coordinate in the world.
class CoordinateAccessibilityElement: UIAccessibilityElement {
    
    let coordinate: Coordinate
    weak var world: GridWorld?
    
    /// Override `accessibilityLabel` to always return updated information about world state.
    override var accessibilityLabel: String? {
        get {
            return world?.speakableContents(of: coordinate)
        }
        set {}
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            var traits = super.accessibilityTraits
            if world?.existingCharacter(at: coordinate) != nil {
                // Resolving migration issue: https://swift.org/migration-guide-swift4.2/
                let rawTraits = traits.rawValue
                let rawTrait = UIAccessibilityTraits.startsMediaSession.rawValue
                let newRawTraits = rawTraits | rawTrait
                traits = UIAccessibilityTraits(rawValue: newRawTraits)
            }
            
            return traits
        }
        set {}
    }
    
    init(coordinate: Coordinate, inWorld world: GridWorld, view: UIView) {
        self.coordinate = coordinate
        self.world = world
        super.init(accessibilityContainer: view)
    }
}

/// Provides an overall description of the `GridWorld`.
class GridWorldAccessibilityElement: UIAccessibilityElement {
    weak var world: GridWorld?
    
    override var accessibilityLabel: String? {
        get {
            return world?.speakableDescription
        }
        set {}
    }
    
    override var accessibilityHint: String? {
        get {
            return NSLocalizedString("To repeat this description, touch outside of the world grid.", comment: "AX hint")
        }
        set {}
    }
    
    init(world: GridWorld, view: UIView) {
        self.world = world
        super.init(accessibilityContainer: view)
    }
    
    override func accessibilityActivate() -> Bool {
        return false
    }
    
    override open func accessibilityPerformMagicTap() -> Bool {
        if let index = self.world?.findComponent(ofType: AccessibilityComponent<GridWorld>.self) {
            if let component = self.world?.components[index] as? AccessibilityComponent<GridWorld> {
                component.utteranceQueue.stopSpeaking()
                component.completeAllActions()
            }
        }
        return true
    }
}

// MARK: SceneController Accessibility

extension SceneController {
    
    private var voiceOverStatusDidChangeNotificationName: Notification.Name  {
        return UIAccessibility.voiceOverStatusDidChangeNotification
    }
    
    private var announcementDidFinishNotificationName: Notification.Name  {
        return UIAccessibility.announcementDidFinishNotification
    }
    
    func registerForAccessibilityNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(voiceOverStatusChanged), name: voiceOverStatusDidChangeNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(voiceOverAnnouncementDidFinish), name: announcementDidFinishNotificationName, object: nil)
    }
    
    func unregisterForAccessibilityNotifications() {
        NotificationCenter.default.removeObserver(self, name: voiceOverStatusDidChangeNotificationName, object: nil)
        NotificationCenter.default.removeObserver(self, name: announcementDidFinishNotificationName, object: nil)
    }
    
    @objc func voiceOverStatusChanged() {
        DispatchQueue.main.async {
            self.setVoiceOverForCurrentStatus(forceLayout: true)
        }
    }
    
    @objc func voiceOverAnnouncementDidFinish(_ notification: NSNotification) {
        guard voiceOverAnnouncementDidFinishCompletion != nil else { return }
        DispatchQueue.main.async {
            self.voiceOverAnnouncementDidFinishCompletion?()
            self.voiceOverAnnouncementDidFinishCompletion = nil
        }
    }
    
    /**
     Configures the scene to account for the current VoiceOver status.
     - parameters:
     - forceLayout: Passing `true` will force the accessibility elements
     to be recalculated for the current grid.
     */
    func setVoiceOverForCurrentStatus(forceLayout: Bool = false) {
        // Ensure the view is loaded and the `characterPicker` is not presented.
        guard isViewLoaded, characterPicker == nil else { return }
        
        if UIAccessibility.isVoiceOverRunning {
            scnView.gesturesEnabled = false
            
            // Lazily recompute the `accessibilityElements`.
            if forceLayout || view.accessibilityElements?.isEmpty == true {
                
                DispatchQueue.main.async {
                    self.cameraController?.switchToOverheadView()
                }
                
                view.isAccessibilityElement = false
                view.shouldGroupAccessibilityChildren = true
                view.accessibilityElements = []
                
                // Set up an AX group (Mac Catalyst) for the grid world.
                gridWorldAXContainerView.isHidden = false
                gridWorldAXContainerView.isAccessibilityElement = false
                gridWorldAXContainerView.accessibilityElements = []
                gridWorldAXContainerView.shouldGroupAccessibilityChildren = true
                gridWorldAXContainerView.accessibilityLabel = NSLocalizedString("The World", comment: "AX label for the grid world group")
                                        
                configureAccessibilityElementsForGrid()

                view.accessibilityElements?.append(goalCounter)
                view.accessibilityElements?.append(speedButton)
                view.accessibilityElements?.append(audioButton)
                view.accessibilityElements?.append(gridWorldAXContainerView)
                
                // If we’re forcing a layout and the thing that’s already focused is the GridWorld, this can cause the GridWorld description to repeat and be cut off several times in quick succession.
                let focusedElement = UIAccessibility.focusedElement(using: nil)
                if focusedElement == nil {
                    UIAccessibility.post(notification: .screenChanged, argument: gridWorldAXContainerView)
                }
            }
            
            // Add an AccessibilityComponent to each actor.
            for actor in scene.actors
                where actor.component(ofType: AccessibilityComponent<Actor>.self) == nil {
                    actor.addComponent(AccessibilityComponent<Actor>(component: actor))
            }
            
            
            // Add custom actions to provide details about the world.
            accessibilityCustomActions = [
                UIAccessibilityCustomAction(name: NSLocalizedString("Character Locations", comment: "AX action label"), target: self, selector: #selector(announceCharacterLocations)),
                UIAccessibilityCustomAction(name: NSLocalizedString("Goal Locations", comment: "AX action label"), target: self, selector: #selector(announceGoalLocations))
            ]
            
            if let _ = scene.mainActor {
                let action = UIAccessibilityCustomAction(name: NSLocalizedString("Character Description", comment: "AX action label"), target: self, selector: #selector(announceCharacterDescription))
                accessibilityCustomActions?.append(action)
            }
            
            // Add an action for random items only when there are random items.
            if scene.gridWorld.grid.allItems.contains(where: { $0 is RandomNode }) {
                let action = UIAccessibilityCustomAction(name: NSLocalizedString("Random Item Locations", comment: "AX action label"), target: self, selector: #selector(announceRandomItems))
                accessibilityCustomActions?.append(action)
            }
            
            if scene.gridWorld.component(ofType: AccessibilityComponent<GridWorld>.self) == nil {
                scene.gridWorld.addComponent(AccessibilityComponent<GridWorld>(component: scene.gridWorld))
            }
        }
        else {
            scnView.gesturesEnabled = true
            cameraController?.resetFromVoiceOver()

            gridWorldAXContainerView.isHidden = true
            
            for actor in scene.actors {
                actor.removeComponent(ofType: AccessibilityComponent<Actor>.self)
            }
            
            scene.gridWorld.removeComponent(ofType: AccessibilityComponent<GridWorld>.self)
        }
    }
    
    private func configureAccessibilityElementsForGrid() {

        var gridRect = CGRect.null

        // Add AX element for each grid cell.
        for coordinate in scene.gridWorld.columnRowSortedCoordinates {
            let gridPosition = coordinate.position
            let rootPosition = scene.gridWorld.grid.scnNode.convertPosition(gridPosition, to: nil)
            
            let offset = WorldConfiguration.coordinateLength / 2
            let upperLeft = scnView.projectPoint(SCNVector3(rootPosition.x - offset, rootPosition.y, rootPosition.z - offset))
            let lowerRight = scnView.projectPoint(SCNVector3(rootPosition.x + offset, rootPosition.y, rootPosition.z + offset))
            
            let point = CGPoint(x: CGFloat(upperLeft.x), y: CGFloat(upperLeft.y))
            let size = CGSize (width: CGFloat(lowerRight.x - upperLeft.x), height: CGFloat(lowerRight.y - upperLeft.y))
            
            let element = CoordinateAccessibilityElement(coordinate: coordinate, inWorld: scene.gridWorld, view: gridWorldAXContainerView)
            let elementRect = CGRect(origin: point, size: size)
            gridRect = gridRect.union(elementRect)
            element.accessibilityFrame = elementRect
            gridWorldAXContainerView.accessibilityElements?.append(element)
        }
        
        // Add AX element for the grid world.
        let gridAXElement = GridWorldAccessibilityElement(world: scene.gridWorld, view: gridWorldAXContainerView)
        gridWorldAXContainerView.accessibilityElements?.append(gridAXElement)
        
        // Set AX frame to match that of the grid world, with some padding all around
        // so it can be tapped without hitting a grid cell.
        gridRect = gridRect.insetBy(dx: -60, dy: -60)
        gridAXElement.accessibilityFrame = gridRect
        gridWorldAXContainerView.accessibilityFrame = gridRect.insetBy(dx: -20, dy: -20)
    }
    
    // MARK: Custom Actions
    func announce(speakableDescription: String) {
        UIAccessibility.post(notification: .announcement, argument: speakableDescription)
    }
    
    @objc func announceCharacterLocations() -> Bool {
        announce(speakableDescription: scene.gridWorld.speakableActorLocations())
        return true
    }
    
    @objc func announceGoalLocations() -> Bool {
        announce(speakableDescription: scene.gridWorld.speakableGoalLocations())
        return true
    }
    
    @objc func announceRandomItems() -> Bool {
        let world = scene.gridWorld
        announce(speakableDescription: world.speakableRandomLocations())
        return world.grid.allItems.contains(where: { $0 is RandomNode })
    }
    
    @objc func announceCharacterDescription() -> Bool {
        if let actor = scene.mainActor {
            let actorDescription = "\(actor.speakableName). \(actor.speakableCharacterDescription))"
            UIAccessibility.post(notification: .announcement, argument: actorDescription)
            return true
        }
        return false
    }
}

extension GridWorld {
    
    /// Returns all the possible coordinates sorted by column then row.
    var columnRowSortedCoordinates: [Coordinate] {
        return allPossibleCoordinates.sorted(by: columnRowSortPredicate)
    }
    
    var columnRowSortedItems: [Item] {
        return grid.allItemsInGrid.sorted(by: columnRowSortPredicate)
    }
    
    /// Describes the entire contents of the world including all the important locations.
    var speakableDescription: String {
        let format = NSLocalizedString("sd:accessibility_extension.column_row_announcement", comment: "AX world description")
        var description = ""
        description += String.localizedStringWithFormat(format, columnCount, rowCount) + " "
        description += speakableActorLocations() + ". "
        let count = getGoalCount()
        if count == 0 {
            description += speakableGoalLocations()
        }
        else {
            let goalFormat = NSLocalizedString("sd:accessibility_extension.goalDescription", comment: "AX world description. 'goals' will be a list of complete sentences filled in based on the objectives of the currently loaded world")
            description += String.localizedStringWithFormat(goalFormat, count)
            description += speakableGoalLocations()
        }
        description += speakableRandomLocations()
        
        return description
    }
    
    // MARK: Specific queries
    
    func speakableActorLocations() -> String {
        let actors = grid.actors.sorted(by: columnRowSortPredicate)
        
        if actors.isEmpty {
            return NSLocalizedString("There is no character in this world. You must place your own.", comment: "AX world description")
        }
        
        return actors.reduce("") { result, actor in
            result + String(format: NSLocalizedString("%@ on %@", comment: "AX world description. This is describing the location of a thing. {foo} on {coordinate}"), actor.speakableDescription, actor.locationDescription)
        }
    }
    
    func getGoalCount() -> Int {
        let goals = columnRowSortedItems.filter {
            switch $0.identifier {
            case .switch, .portal, .gem, .platformLock: return true
            default: return false
            }
        }
        return goals.count
    }
    
    func speakableGoalLocations() -> String {
        let goals = columnRowSortedItems.filter {
            switch $0.identifier {
            case .switch, .portal, .gem, .platformLock: return true
            default: return false
            }
        }
        
        if goals.isEmpty {
            return NSLocalizedString("No switches or gems found.", comment: "AX world description")
        }
        
        var goalDescription = ""
        for (index, item) in goals.enumerated() {
            goalDescription += String(format: NSLocalizedString("%@ on %@", comment: "AX world description. This is describing the location of a thing. {foo} on {coordinate}"), item.speakableDescription, item.locationDescription)
            goalDescription += index == goals.endIndex ? "." : "; "
        }
        
        return goalDescription
    }
    
    /// Returns the description for all random items that are used for layout
    /// (including if the markers are not currently visible).
    func speakableRandomLocations() -> String {
        let allSortedItems = grid.allItems.sorted(by: columnRowSortPredicate)
        let randomItems = allSortedItems.filter { $0.identifier == .randomNode }
        
        if randomItems.isEmpty {
            // Ignore if no there are no random items.
            return ""
        }
        
        var description = ""
        for (index, item) in randomItems.enumerated() {
            description += String(format: NSLocalizedString("%@ on %@", comment: "AX world description. This is describing the location of a thing. {foo} on {coordinate}"), item.speakableDescription, item.locationDescription)
            description += index == randomItems.endIndex ? "." : "; "
        }
        
        return description
    }
    
    // MARK: Coordinate contents
    
    func speakableContents(of coordinate: Coordinate) -> String {
        let contents = excludingNodes(ofType: Block.self, at: coordinate).reduce("") { str, item in
            let prefix: String
            if type(of: item) == Actor.self, shouldShowPicker(from: item.scnNode) {
                prefix = ". " + NSLocalizedString("Double-press to switch characters.", comment: "AX world description")
            } else {
                prefix = ", "
            }
            return str + item.speakableDescription + prefix
        }
        
        let prefix = !contents.isEmpty ? contents : blockDescription(at: coordinate)
        let suffix = ", \(coordinate.description)"
        
        return completeSentence(prefix + suffix)
    }
    
    // MARK: Helper Methods
    
    /// Returns if the coordinate contains a block, or is unreachable.
    func blockDescription(at coordinate: Coordinate) -> String {
        guard let block = topBlock(at: coordinate) else {
            return NSLocalizedString("is unreachable.", comment: "AX world description. The subject that 'is unreachable' is defined dynamically. e.g., {thing},{row x col y}, is unreachable.")
        }
        return block.description(with: [.name, .height])
    }
    
    /// Removes ", " from the end of a string and replaces it with ".".
    private func completeSentence(_ sentence: String) -> String {
        let end = sentence.suffix(2)
        guard String(end) == ", " else { return sentence + "." }
        
        return String(sentence.dropLast(2)) + "."
    }
    
    func columnRowSortPredicate(_ item1: Item, _ item2: Item) -> Bool {
        return columnRowSortPredicate(item1.coordinate, item2.coordinate)
    }
    
    func columnRowSortPredicate(_ coor1: Coordinate, _ coor2: Coordinate) -> Bool {
        #if targetEnvironment(macCatalyst)
        if coor1.row == coor2.row {
            return coor1.column < coor2.column
        }
        return coor1.row < coor2.row
        #else
        if coor1.column == coor2.column {
            return coor1.row < coor2.row
        }
        return coor1.column < coor2.column
        #endif
    }
}
