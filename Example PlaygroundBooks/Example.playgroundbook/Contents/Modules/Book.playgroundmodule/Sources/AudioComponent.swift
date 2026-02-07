//
//  AudioComponent.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import SceneKit

class AudioComponent: ActorComponent, ActorNode {
    
    /// Indicates what events are playing so that the same audio is not 
    /// played from multiple actors.
    private static var playingEventsByType = [ActorType: [EventVariation]]()
    
    static func shouldWorkaroundBluetoothAudio() -> Bool {
        var workaround = false
        
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 14.0, *) {
            
        } else {
            // workaround on Catalina only
            workaround = true
        }
        #endif
        
        return workaround
    }
    
    // MARK: Properties
    
    unowned let actor: Actor
        
    var soundCache: AssetCache {
        return AssetCache.cache(forType: self.actor.type)
    }
    
    var playingEvents: [EventVariation] {
        get {
            return AudioComponent.playingEventsByType[actor.type] ?? []
        }
        
        set {
            AudioComponent.playingEventsByType[actor.type] = newValue
        }
    }
    
    required init(actor: Actor) {
        self.actor = actor
    }

    // MARK: Performer
    
    func cancel(_ action: Action) {
        node.removeAllAudioPlayers()
        
        if let event = action.event {
            remove(event: event)
        }
    }
    
    // MARK: ActorComponent
    
    func perform(event: EventGroup, variation index: Int, speed: Float)  -> PerformerResult {
        let variation = EventVariation(event: event, variationIndex: index)
        
        // Make sure the source exists and is not already playing.
        guard let source = soundCache.sound(for: variation),
            !playingEvents.contains(variation) else {
            return .done(self)
        }
        let eventsCount = Float(allPlayingEventsCount())
        playingEvents.append(variation)
        
        // Adjust the playback properties.
        source.rate = speed
        source.loops = false
        
        // Modulate the volume based on the number of character sounds playing.
        source.volume = eventsCount < 1 ? 1 : 1 / eventsCount

        // Make sure the node is not hidden, otherwise audio will not play.
        node.isHidden = false
        
        // Start playing the audio.
        if !AudioComponent.shouldWorkaroundBluetoothAudio() {
            self.node.runAction(SCNAction.playAudio(source, waitForCompletion: false), forKey:"Actor Audio")
        }
        
        // Delay for a set offset before allowing the variation to be used again.
        let offset = WorldConfiguration.Actor.audioDelay / Double(speed)
        DispatchQueue.main.asyncAfter(deadline: .now() + offset) { [weak self] in
            self?.remove(eventVariation: variation)
        }
        
        // Don’t allow the audio component to block other components.
        return .done(self)
    }
    
    // MARK: Playing Events
    
    func allPlayingEventsCount() -> Int {
        // If we try to return flatMap({$0}).count directly, there is an ambiguity for the compiler of which version of flatMap
        let mappedValues = AudioComponent.playingEventsByType.values.flatMap({$0})
        return mappedValues.count
    }
    
    /// Removes the specific `EventVariation` associated.
    func remove(eventVariation: EventVariation) {
        let remainingEvents = playingEvents.filter {
            return $0 != eventVariation
        }
        
        playingEvents = remainingEvents
    }
    
    /// Removes all `EventVariations` associated with this event.
    func remove(event: EventGroup) {
        let remainingEvents = playingEvents.filter {
            return $0.event != event
        }
        
        playingEvents = remainingEvents
    }
}
