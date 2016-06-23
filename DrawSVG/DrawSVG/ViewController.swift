//
//  ViewController.swift
//  DrawSVG
//
//  Created by Matthew Tso on 4/27/16.
//  Copyright © 2016 De Anza. All rights reserved.
//

import UIKit
import PocketSVGFramework

class ViewController: UIViewController {
    
    @IBOutlet var bangButton: UIButton!

    /// The loaded CGPath from the SVG_Assets folder.
    let CGPath = PocketSVG.pathFromSVGFileNamed("lumpy_donuts").takeUnretainedValue()
    var paths = [CAShapeLayer]()
    
    /// Crazy Mode approximately doubles the number of `CAShapeLayers` drawn.
    var crazyMode:Bool = false {
        didSet {
            bangButton.layer.borderColor = (crazyMode ? UIColor.whiteColor() : UIColor.blackColor()).CGColor
            bangButton.backgroundColor   =  crazyMode ? UIColor.blackColor() : UIColor.whiteColor()
            
            crazyMode ?
                bangButton.setTitle("!",   forState: .Normal) :
                bangButton.setTitle("!!!", forState: .Normal)
            crazyMode ?
                bangButton.setTitleColor(UIColor.whiteColor(), forState: .Normal) :
                bangButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial border style
        bangButton.layer.borderColor = UIColor.blackColor().CGColor
        bangButton.layer.borderWidth = 2
        
        generateLayers(crazyMode: crazyMode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /// For animating the stroking of the CAShapeLayer.
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 5
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        // Creates a ripple animation beginning from the location of touch contact.
        if let touch = touches.first {
            let location = touch.locationInView(view)
            
            for path in paths {
                let deltaX = location.x - path.position.x
                let deltaY = location.y - path.position.y
                let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
                
                pathAnimation.beginTime = CACurrentMediaTime() + Double(distance * 0.003)
                path.addAnimation(pathAnimation, forKey: "strokeAnimation")
            }
        }
    }
    
    /// Toggles crazy mode.
    @IBAction func bangButtonClick(sender: AnyObject) {
        crazyMode = !crazyMode
        generateLayers(crazyMode: crazyMode)
    }
    
    /// Remove all previous shape layers and draw a new set based on Crazy Mode boolean toggle.
    func generateLayers(crazyMode crazyMode: Bool) {

        let rows    = crazyMode ? 62 : 31
        let columns = crazyMode ? 36 : 18
        let spacing = crazyMode ? 12 : 24
        let offset  = crazyMode ? 08 : 04
        
        for path in paths {
            path.removeFromSuperlayer()
        }
        paths.removeAll()
        
        for i in 0..<rows {
            for j in 0..<columns {
                let pathLayer = CAShapeLayer()
                pathLayer.path = CGPath
                pathLayer.fillColor = nil
                pathLayer.strokeColor = UIColor.blackColor().CGColor
                pathLayer.lineWidth = 1
                
                pathLayer.position = CGPoint(
                    x: pathLayer.position.x + CGFloat(j * spacing) - CGFloat(offset),
                    y: pathLayer.position.y + CGFloat(i * spacing) - CGFloat(offset))
                
                paths.append(pathLayer)
                view.layer.insertSublayer(pathLayer, below: bangButton.layer)
            }
        }
    }
}
