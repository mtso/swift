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
    
    var playButton: UIButton?
    var rope: UIImageView?
    var threshold: UIImageView?
    
    var displayLink: CADisplayLink!
    
    var previousUpdateTime: NSTimeInterval = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // Set up CADisplayLink for the game update loop.
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        view.backgroundColor = UIColor.whiteColor()
        
        playButton = UIButton(type: UIButtonType.System)
        playButton?.addTarget(self, action: #selector(playButtonClick), forControlEvents: .TouchUpInside)
        playButton?.backgroundColor = UIColor.grayColor()
        playButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        playButton?.alpha = 0

        rope = UIImageView(image: UIImage(named: "rope"))
        threshold = UIImageView(image: UIImage(named: "threshold"))
        
        view.addSubview(threshold!)
        view.addSubview(rope!)
        view.addSubview(playButton!)
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
            playerTugAction()

        default:
            break
        }
    }
    
    func playButtonClick() {
        stateMachine.enterState(GamePlayingState.self)
    }
    
    func playerTugAction() {
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.rope!.frame.origin.y += pullDistance
            }, completion: { _ in
                self.checkGameOver()
        })
    }
    
    func opponentTugAction() {
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.rope!.frame.origin.y -= pullDistance
            }, completion: { _ in
                self.checkGameOver()
        })
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
