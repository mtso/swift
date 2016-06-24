//
//  GameViewController.swift
//  War of Tug
//
//  Created by Matthew Tso on 6/23/16.
//  Copyright © 2016 Matthew Tso. All rights reserved.
//

import UIKit
import GameplayKit

class GameViewController: UIViewController {

    /**
        Controls the state of the game. This is not modified after
        it is configured in `viewDidLoad()`.
    */
    var stateMachine: GKStateMachine!
    
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
        
        let viewCenter = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))

        var playButtonTitle: String?
        if let asset = NSDataAsset(name: "play_button_title") {
            playButtonTitle = String(data: asset.data, encoding: NSUTF8StringEncoding)
        }

        let buttonSize = CGSize(width: 160, height: 40)
        
        playButton = UIButton(type: UIButtonType.System)
        playButton?.addTarget(self, action: #selector(playButtonClick), forControlEvents: .TouchUpInside)
        playButton?.backgroundColor = UIColor.grayColor()
        
        playButton?.frame = CGRect(
            x: viewCenter.x - buttonSize.width / 2,
            y: viewCenter.y - buttonSize.height / 2,
            width: buttonSize.width,
            height: buttonSize.height)

        playButton?.setTitle(playButtonTitle, forState: .Normal)
        playButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        playButton?.alpha = 0
        
        rope = UIImageView(image: UIImage(named: "rope"))
        rope?.frame = CGRect(x: viewCenter.x - rope!.frame.width / 2, y: viewCenter.y - rope!.frame.height / 2,
                             width: rope!.frame.width, height: rope!.frame.height)
        
        let ropeShrunk = CATransform3DMakeScale(1, 0, 1)
        rope?.layer.transform = ropeShrunk
        
        threshold = UIImageView(image: UIImage(named: "threshold"))
        threshold?.frame = CGRect(x: viewCenter.x - threshold!.frame.width / 2, y: viewCenter.y - threshold!.frame.height / 2,
                             width: threshold!.frame.width, height: threshold!.frame.height)
        
        let thresholdShrunk = CATransform3DMakeScale(0, 1, 1)
        threshold?.layer.transform = thresholdShrunk
        
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
            self.rope!.frame.origin.y += 20
            }, completion: { _ in
                self.checkGameOver()
        })
    }
    
    func opponentTugAction() {
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.rope!.frame.origin.y -= 20
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
        
        stateMachine.updateWithDeltaTime(timeSincePreviousUpdate)

        previousUpdateTime = displayLink.timestamp
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
