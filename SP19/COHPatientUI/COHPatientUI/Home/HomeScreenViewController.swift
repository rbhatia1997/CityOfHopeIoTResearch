//
//  HomeScreenViewController.swift
//  COHPatientUI
//
//  Created by Darien Joso on 2/21/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    // Outlets
    @IBOutlet weak var moodRating: MoodRating!
    
    //////////////////////
    // Global Variables //
    //////////////////////
    
    // Layer needs to be referenced by other methods
    var progressLayer: [CAShapeLayer] = []
    var trackLayer: [CAShapeLayer] = []
    
    // number of exercises, max 8
    let exerciseNum = 2
    
    // radius array
    let radiusArray: [CGFloat] = [100, 80]
    var endAngleArray: [CGFloat] = [180/360, 150/360]
    
    // circular path array
    var trackPath = [UIBezierPath]()
    var circularPath = [UIBezierPath]()
    
    // default color
    let lightSkyBlueArray: [CGColor] = [UIColor(red: 241/255, green: 248/255, blue: 252/255, alpha: 1.0).cgColor,
                                 UIColor(red: 228/255, green: 241/255, blue: 249/255, alpha: 1.0).cgColor,
                                 UIColor(red: 214/255, green: 234/255, blue: 246/255, alpha: 1.0).cgColor,
                                 UIColor(red: 201/255, green: 227/255, blue: 243/255, alpha: 1.0).cgColor,
                                 UIColor(red: 188/255, green: 220/255, blue: 240/255, alpha: 1.0).cgColor,
                                 UIColor(red: 174/255, green: 213/255, blue: 237/255, alpha: 1.0).cgColor,
                                 UIColor(red: 161/255, green: 206/255, blue: 234/255, alpha: 1.0).cgColor,
                                 UIColor(red: 147/255, green: 199/255, blue: 231/255, alpha: 1.0).cgColor,
                                 UIColor(red: 134/255, green: 192/255, blue: 228/255, alpha: 1.0).cgColor,
                                 UIColor(red: 121/255, green: 185/255, blue: 225/255, alpha: 1.0).cgColor,
                                 UIColor(red: 108/255, green: 166/255, blue: 202/255, alpha: 1.0).cgColor,
                                 UIColor(red: 96/255, green: 148/255, blue: 180/255, alpha: 1.0).cgColor]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // center of the screen, offset downwards by 100
        let center = CGPoint.init(x: view.center.x, y: view.center.y + 100)
        
        for index in 0..<exerciseNum {
            
            // define the track path
            trackPath.append(UIBezierPath(arcCenter: center, radius: radiusArray[index], startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true))
            
            // make space in the array
            trackLayer.append(CAShapeLayer())
            
            // drawing the track
            trackLayer[index].path = trackPath[index].cgPath
            trackLayer[index].strokeColor = lightSkyBlueArray[index]
            trackLayer[index].lineWidth = 15
            trackLayer[index].fillColor = UIColor.clear.cgColor
            view.layer.addSublayer(trackLayer[index])
            
            // define the progress circle path
            circularPath.append(UIBezierPath(arcCenter: center, radius: radiusArray[index], startAngle: -CGFloat.pi / 2, endAngle: endAngleArray[index] * 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true))
            
            // make space in the array
            progressLayer.append(CAShapeLayer())
            
            // drawing the circle
            progressLayer[index].path = circularPath[index].cgPath
            progressLayer[index].strokeColor = lightSkyBlueArray[index + 4]
            progressLayer[index].lineWidth = 15
            progressLayer[index].fillColor = UIColor.clear.cgColor
            progressLayer[index].lineCap = CAShapeLayerLineCap.round
            progressLayer[index].strokeEnd = 0
            view.layer.addSublayer(progressLayer[index])
            
        }
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 1
        
        // Animation should "stick" after it completes (does not disappear after completion)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        for index in 0..<exerciseNum {
            progressLayer[index].add(basicAnimation, forKey: "yeet")
        }
        
//         adding tap gesture (make sure to include "Tap" in UITapGestureRecgonizer)
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print("home tab tap detected")
//    }
//
//    @objc private func handleTap() {
////        print("Tap recognized")
//
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//
//        basicAnimation.toValue = 1
//
//        basicAnimation.duration = 1
//
//        // Animation should "stick" after it completes (does not disappear after completion)
//        basicAnimation.fillMode = .forwards
//        basicAnimation.isRemovedOnCompletion = false
//
//        for index in 0..<exerciseNum {
//            progressLayer[index].add(basicAnimation, forKey: "yeet")
//        }
//    }
    
    func addExercise() {
        
    }
}
