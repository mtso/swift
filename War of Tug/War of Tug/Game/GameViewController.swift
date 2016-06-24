//
//  GameViewController.swift
//  War of Tug
//
//  Created by Matthew Tso on 6/23/16.
//  Copyright © 2016 Matthew Tso. All rights reserved.
//

import UIKit
import GameplayKit

let NormalScale = CATransform3DMakeScale(1, 1, 1)
let ZeroScaleX  = CATransform3DMakeScale(0.001, 1, 1)
let ZeroScaleY  = CATransform3DMakeScale(1, 0.001, 1)

class GameViewController: UIViewController {

    /**
        Controls the state of the game. This is not modified after
        it is configured in `viewDidLoad()`.
    */
    var stateMachine: GKStateMachine!
    
    let pullDistance: CGFloat = 20
    
    // Game objects
    var button: UIButton?
    var rope: UIImageView?
    var threshold: UIImageView?
    
    // Game update loop objects
    var displayLink: CADisplayLink!
    var previousUpdateTime: NSTimeInterval = 0
    
    enum Entity {
        case Player
        case Opponent
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // Set up CADisplayLink for the game update loop.
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        view.backgroundColor = UIColor.whiteColor()
        
        button = UIButton(type: UIButtonType.System)
        button?.addTarget(self, action: #selector(buttonClick), forControlEvents: .TouchUpInside)
        button?.backgroundColor = UIColor.grayColor()
        button?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button?.alpha = 0

        rope = UIImageView(image: UIImage(named: "rope"))
        threshold = UIImageView(image: UIImage(named: "threshold"))
        
        view.addSubview(threshold!)
        view.addSubview(rope!)
        view.addSubview(button!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Creates and adds states to the game's state machine.
        stateMachine = GKStateMachine(states: [
            GameStartState(game: self),
            GamePlayingState(game: self),
            GameWinState(game: self),
            GameLoseState(game: self),
            GameTransitionState(game: self),
        ])
        
    }
    
    override func viewDidAppear(animated: Bool) {
        stateMachine.enterState(GameStartState.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch stateMachine.currentState {
        case is GamePlayingState:
            tugAction(entity: .Player)
//            playerTugAction()

        default:
            break
        }
    }
    
    func buttonClick() {
        stateMachine.enterState(GamePlayingState.self)
    }
    
    func tugAction(entity who: Entity) -> () {

        func tugAction() {
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.rope!.frame.origin.y += who == .Player ? self.pullDistance : -self.pullDistance
                }, completion: { _ in
                    self.checkGameOver()
            })
        }

        return tugAction()
    }
    

    
    func checkGameOver() {
        if rope?.frame.origin.y > threshold?.frame.origin.y {
            stateMachine.enterState(GameWinState)
        } else if rope!.frame.origin.y + rope!.frame.height < threshold!.frame.origin.y + threshold!.frame.height {
            stateMachine.enterState(GameLoseState)
        }
    }
    
    func update() {
        let timeSincePreviousUpdate = displayLink.timestamp - previousUpdateTime
        previousUpdateTime = displayLink.timestamp

        stateMachine.updateWithDeltaTime(timeSincePreviousUpdate)
    }

}
