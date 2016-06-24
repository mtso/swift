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
    
    static let transitionInterval: NSTimeInterval = 2.0
    var transitionTimeCounter: NSTimeInterval = 0
    
    var particleEmitter: CAEmitterLayer?

    override func didEnterWithPreviousState(previousState: GKState?) {
        particleEmitter = CAEmitterLayer()
        particleEmitter?.emitterPosition = controller.view.center
        particleEmitter?.emitterShape = kCAEmitterLayerCircle
        particleEmitter?.emitterSize = controller.view.frame.size
        
        let particle = CAEmitterCell()
        particle.birthRate = 50
        particle.lifetime = 1
        particle.lifetimeRange = 0
        particle.color = UIColor.blackColor().CGColor
        particle.velocity = 200
        particle.spin = 1
        particle.scaleSpeed = -0.5
        particle.contents = UIImage(named: "tug_particle")?.CGImage
        
        particleEmitter?.emitterCells = [particle]
        
        controller.view.layer.addSublayer(particleEmitter!)
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is GameStartState.Type
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        transitionTimeCounter += seconds
        
        let percentage = (GameTransitionState.transitionInterval - transitionTimeCounter) / GameTransitionState.transitionInterval
        
        particleEmitter?.birthRate = Float(5 * percentage * seconds)
        
        if transitionTimeCounter > GameTransitionState.transitionInterval {
            stateMachine?.enterState(GameStartState.self)
            
            transitionTimeCounter = 0
        }

    }
    
}
