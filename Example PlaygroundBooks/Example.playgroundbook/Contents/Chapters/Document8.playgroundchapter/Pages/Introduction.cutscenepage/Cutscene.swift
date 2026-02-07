import PlaygroundSupport
import SPCCutsceneSupport
import Document8_Cutscenes
import UIKit

let vc = CutsceneContainerViewController(storyboardName: "HB_C08_Variables",
                                         storyboardIDs: [ "Scene 1", "Scene 2", "Scene 3", "Scene 4", "Scene 5", "Scene 6", "Scene 7" ],
                                         displaysPagingButtons: true)
vc.needsIncreasedScaling = false
vc.view.backgroundColor = UIColor(named: "LTC1_Background_Blue")

PlaygroundPage.current.liveView = vc
