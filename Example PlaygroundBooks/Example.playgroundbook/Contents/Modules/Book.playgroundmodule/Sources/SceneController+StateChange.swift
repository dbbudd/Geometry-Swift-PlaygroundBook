//
//  SceneController+StateChange.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import SceneKit

extension SceneController: SceneStateDelegate {
    // MARK: GridWorldStateDelegate
    
    func scene(_ scene: Scene, didEnterState state: Scene.State) {
        switch state {
        case .initial, .built, .ready:
            break
            
        case .run:
            
            updateCounterLabelRunningCounts()
            updateCounterLabelTotals()
            
        case .done:
            sceneCompleted(scene: scene)
            sendAssessmentMessage()
        }
    }
    
    // MARK: End State
    
    func sceneCompleted(scene: Scene) {
        // Determine if there is anything interesting to show.
        let hasCommands = !scene.commandQueue.completedCommands(for: scene.mainActor).isEmpty
        
        // Increment the run count for the page once the scene has completed.
        currentPageRunCount += 1
        
        guard hasCommands else {
            startIdleForAllCharacters()
            return
        }
        
        if isPassingRun {
            showSuccessState()
        }
        else {
            showDefeatedState()
        }
    }
    
    // MARK: Animations
    
    func startIdleForAllCharacters() {
        for actor in scene.actors {
            actor.startContinuousIdle()
        }
    }
    
    func showDefeatedState() {
        // Show the character defeated.
        for actor in scene.actors {
            actor.idleQueue.start(initialAnimations: [.defeat])
        }
        
        let actorType = scene.actors.first?.type ?? ActorType.loadDefault()
        
        let format = NSLocalizedString("The level is incomplete, %@ looks sad. Press the hint button for more details.", comment: "{character name} looks sad.")
        let defeatMessage = String.localizedStringWithFormat(format, actorType.rawValue)
        UIAccessibility.post(notification: .announcement, argument: defeatMessage)
    }

    func showSuccessState() {
        guard let mainActor = scene.mainActor else { return }

        // Disable gesture recognizers while camera pans.
        view.gesturesEnabled = false
        
        // Play congratulations song.
        audioController.playSuccess()

        let (duration, _) = cameraController?.performFlyover(toFace: mainActor.rotation, completion: {
            DispatchQueue.main.async {
                // Re-enable gestures after flyover completes.
                self.view.gesturesEnabled = true
            }
        }) ?? (0, 0)
        
        for actor in scene.actors {
            let successAnimations: [EventGroup] = [.celebration, .victory]
            
            let shortenedDuration = duration * 0.7
            DispatchQueue.main.asyncAfter(deadline: .now() + shortenedDuration) {
                actor.idleQueue.start(initialAnimations: successAnimations)
            }
        }
    }
}
