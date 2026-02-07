
import PlaygroundSupport
import SPCCutsceneSupport
import Document5_Cutscenes
import UIKit

let vc = CutsceneContainerViewController(storyboardName: "LTC1_C05_LogicalOps",
                                         storyboardIDs: ["Page 1", "Page 2", "Page 3", "Page 4", "Page 5", "Page 6", "Page 7", "Page 8", "Page 9", "Page 10"],
                                         displaysPagingButtons: true)
vc.needsIncreasedScaling = false
vc.view.backgroundColor = UIColor(named:"LTC1_Background_Blue")

PlaygroundPage.current.liveView = vc
