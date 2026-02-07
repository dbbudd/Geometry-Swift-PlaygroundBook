
import PlaygroundSupport
import SPCCutsceneSupport
import Document1_Cutscenes
import UIKit

let vc = CutsceneContainerViewController(storyboardName: "HB_C01_Commands",
                                         storyboardIDs: [ "Page 1", "Page 2", "Page 3", "Page 4", "Page 5", "Page 6", "Page 7", "Page 8" ],
                                         displaysPagingButtons: true)
vc.needsIncreasedScaling = false
vc.view.backgroundColor = UIColor(named:"LTC1_Background_Blue")

PlaygroundPage.current.liveView = vc
