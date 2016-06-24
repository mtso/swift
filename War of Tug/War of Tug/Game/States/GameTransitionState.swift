//
//  GameTransitionState.swift
//  War of Tug
//
//  Created by Matthew Tso on 6/24/16.
//  Copyright © 2016 Matthew Tso. All rights reserved.
//

import UIKit
import GameplayKit

class GameTransitionState: GameState {

    override func didEnterWithPreviousState(previousState: GKState?) {
        <#code#>
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is GameStartState.Type
    }
    
}
