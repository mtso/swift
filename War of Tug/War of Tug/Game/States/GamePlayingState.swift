//
//  GamePlayingState.swift
//  War of Tug
//
//  Created by Matthew Tso on 6/24/16.
//  Copyright © 2016 Matthew Tso. All rights reserved.
//

import UIKit
import GameplayKit

class GamePlayingState: GameState {

    static let opponentTugInterval: NSTimeInterval = 1.0
    var tugTimeCounter: NSTimeInterval = 0
    
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let extend = CATransform3DMakeScale(1, 1, 1)
        let shrink = CATransform3DMakeScale(1, 0, 1)
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
            self.controller.rope?.layer.transform = extend
            self.controller.threshold?.layer.transform = extend
            self.controller.playButton?.layer.transform = shrink
            
            }, completion: nil)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        tugTimeCounter += seconds
        
        if tugTimeCounter > GamePlayingState.opponentTugInterval {
            controller.opponentTugAction()
            tugTimeCounter = 0
        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameWinState.Type, is GameLoseState.Type:
            return true
            
        default:
            return false
        }
    }
    
}
