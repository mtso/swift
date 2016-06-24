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

        UIView.animateWithDuration(1, animations: {
            self.controller.playButton?.alpha = 1
        })
        self.controller.playButton?.alpha = 1
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is GamePlayingState.Type
    }
}
