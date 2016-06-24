//
//  GameStartState.swift
//  War of Tug
//
//  Created by Matthew Tso on 6/24/16.
//  Copyright © 2016 Matthew Tso. All rights reserved.
//

import UIKit
import GameplayKit

class GameStartState: GameState {

    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        let view = controller.view
        
        if let rope = controller.rope{
            rope.frame = CGRect(x: view.center.x - rope.frame.width / 2,
                                y: view.center.y - rope.frame.height / 2,
                                width: rope.frame.width, height: rope.frame.height)

            rope.layer.transform = ZeroScaleY

        }
        
        if let threshold = controller.threshold {
            threshold.frame = CGRect(x: view.center.x - threshold.frame.width / 2,
                                     y: view.center.y - threshold.frame.height / 2,
                                     width: threshold.frame.width, height: threshold.frame.height)
            
            threshold.layer.transform = ZeroScaleX
        }
        
        if let playButton = controller.playButton {
            let buttonSize = CGSize(width: 160, height: 40)
            
            playButton.frame = CGRect(
                x: view.center.x - buttonSize.width / 2,
                y: view.center.y - buttonSize.height / 2,
                width: buttonSize.width,
                height: buttonSize.height)
            
            UIView.animateWithDuration(0.5, animations: {
                playButton.alpha = 1
                playButton.layer.transform = NormalScale
            })
        }

        
        var playButtonTitle: String?
        if let asset = NSDataAsset(name: "play_button_title") {
            playButtonTitle = String(data: asset.data, encoding: NSUTF8StringEncoding)
        }
        controller.playButton?.setTitle(playButtonTitle, forState: .Normal)
    }
    
    override func willExitWithNextState(nextState: GKState) {
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
            self.controller.rope?.layer.transform = NormalScale
            self.controller.threshold?.layer.transform = NormalScale
            self.controller.playButton?.layer.transform = ZeroScaleY
            }, completion: nil)
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is GamePlayingState.Type
    }
}
