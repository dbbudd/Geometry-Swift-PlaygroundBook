
import PlaygroundSupport
import SPCCutsceneSupport
import Document9_Cutscenes
import UIKit

let vc = CutsceneContainerViewController(storyboardName: "LTC2_C09_Types",
                                         storyboardIDs: [ "Scene 1", "Scene 2", "Scene 3", "Scene 4", "Scene 5", "Scene 6", "Scene 7", "Scene 8" ],
                                         displaysPagingButtons: true)
vc.needsIncreasedScaling = false
vc.view.backgroundColor = UIColor(named: "LTC1_Background_Blue")

PlaygroundPage.current.liveView = vc
