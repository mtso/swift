//
//  GameWinState.swift
//  War of Tug
//
//  Created by Matthew Tso on 6/24/16.
//  Copyright © 2016 Matthew Tso. All rights reserved.
//

import UIKit
import GameplayKit

class GameWinState: GameState {

    override func didEnterWithPreviousState(previousState: GKState?) {
        let extend = CATransform3DMakeScale(1, 1, 1)
        let shrink = CATransform3DMakeScale(1, 0, 1)
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: {
            self.controller.rope?.frame.origin.y = self.controller.view.frame.height
            
            self.controller.threshold?.layer.transform = shrink
            self.controller.playButton?.layer.transform = extend
            
            }, completion: { _ in
                self.stateMachine?.enterState(GameTransitionState)
        })

    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is GameTransitionState.Type
    }
}
