
import PlaygroundSupport
import SPCCutsceneSupport
import Document10_Cutscenes
import UIKit

let vc = CutsceneContainerViewController(storyboardName: "LTC2_C10_Initialization",
                                         storyboardIDs: [ "Scene 1", "Scene 2", "Scene 3", "Scene 4", "Scene 5" ],
                                         displaysPagingButtons: true)
vc.needsIncreasedScaling = false
vc.view.backgroundColor = UIColor(named: "LTC1_Background_Blue")

PlaygroundPage.current.liveView = vc
