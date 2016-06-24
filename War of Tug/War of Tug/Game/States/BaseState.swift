//
//  BaseState.swift
//  War of Tug
//
//  Created by Matthew Tso on 6/23/16.
//  Copyright © 2016 Matthew Tso. All rights reserved.
//

import UIKit
import GameplayKit

class BaseState: GKState {

    let game: GameViewController
    
    init(game: GameViewController) {
        self.game = game
    }
}
