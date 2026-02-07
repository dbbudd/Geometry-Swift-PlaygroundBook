
import PlaygroundSupport
import SPCCutsceneSupport
import Document3_Cutscenes
import UIKit

let vc = CutsceneContainerViewController(storyboardName: "LTC1_C03_ForLoops",
                                         storyboardIDs: [ "Page 1", "Page 2", "Page 3", "Page 4", "Page 5" ],
                                         displaysPagingButtons: true)
vc.needsIncreasedScaling = false
vc.view.backgroundColor = UIColor(named:"LTC1_Background_Blue")

PlaygroundPage.current.liveView = vc
