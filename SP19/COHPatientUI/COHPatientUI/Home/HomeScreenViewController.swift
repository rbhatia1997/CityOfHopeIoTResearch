//
//  HomeScreenViewController.swift
//  COHPatientUI
//
//  Created by Darien Joso on 2/21/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    
    @IBOutlet weak var headerView: Header!
    @IBOutlet weak var homeProgressGraph: NestedCircleGraph!
    @IBOutlet weak var bluetoothConnection: BTConn!
    @IBOutlet weak var homeMotivation: HomeMotivator!
    
    let numOfEx = 5
    var progress = [CGFloat]() // from 0.0 - 1.0
    var progAverage: CGFloat = 0
    var exerciseNames = [String]()
    let colorTheme: UIColor = UIColor(named: "blue") ?? .black // color sets must be [Extended Range sRGB] to work
    let uuid: String = "COH-AMT-1234"
    var goals: [String] = ["Cook for my kids",
                           "Put on makeup by myself",
                           "Tie up my hair",
                           "Shower by myself",
                           "Drive myself to work"]
    
    let singleCircleTitle = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let nestedCircleTitle = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<numOfEx {
            progress.append(CGFloat.random(in: 0..<100) / CGFloat(100)) // add random value between 0 and 100
            progAverage += progress[i]
            exerciseNames.append("Exercise \(i+1)")
        }
        progAverage /= CGFloat(progress.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewLoadSetup()
    }
    
    func viewLoadSetup() {
        headerView.setHeader(text: "Hello, Jane", color: colorTheme)
        
        homeMotivation.listGoals(numDisplayGoals: 5, goals: goals)
        
        homeProgressGraph.wipe()
        homeProgressGraph.drawSingleGraph(value: progAverage, color: hsbShadeTint(color: colorTheme, sat: 0.40), rMax: 120, rMin: 90, trackSat: colorTheme.hsba.saturation)
        
        drawTitle(single: true)
        singleCircleTitle.addTarget(self, action: #selector(resetSingleGraph), for: .touchUpInside)
        nestedCircleTitle.addTarget(self, action: #selector(resetNestedGraph), for: .touchUpInside)
        
        bluetoothConnection.printConnection(didConnect: true, serviceUUID: uuid)
    }
    
    func drawTitle(single: Bool) {
        
        let newOrigin = self.view.convert(homeProgressGraph.frame.origin, from: homeProgressGraph)
        
        singleCircleTitle.setTitle("Overall Progress", for: .normal)
        singleCircleTitle.setTitleColor(.gray, for: .normal)
        singleCircleTitle.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14.0)
        singleCircleTitle.sizeToFit()
        singleCircleTitle.titleLabel?.textAlignment = .center
        singleCircleTitle.center.x = homeProgressGraph.frame.width * 0.25 + newOrigin.x
        singleCircleTitle.center.y = newOrigin.y - homeProgressGraph.frame.height + 50
        
        nestedCircleTitle.setTitle("Exercise Progress", for: .normal)
        nestedCircleTitle.setTitleColor(.lightGray, for: .normal)
        nestedCircleTitle.titleLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 14) ?? UIFont.systemFont(ofSize: 14.0)
        nestedCircleTitle.sizeToFit()
        nestedCircleTitle.titleLabel?.textAlignment = .center
        nestedCircleTitle.center.x = homeProgressGraph.frame.width * 0.75 + newOrigin.x
        nestedCircleTitle.center.y = newOrigin.y - homeProgressGraph.frame.height + 50
        
        self.view.addSubview(singleCircleTitle)
        self.view.addSubview(nestedCircleTitle)
    }
    
    @objc func resetSingleGraph() {
//        print("singleTapped")
        
        singleCircleTitle.setTitleColor(.gray, for: .normal)
        singleCircleTitle.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        nestedCircleTitle.setTitleColor(.lightGray, for: .normal)
        nestedCircleTitle.titleLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 14)
        singleCircleTitle.sizeToFit()
        nestedCircleTitle.sizeToFit()
        
        homeProgressGraph.wipe()
        homeProgressGraph.drawSingleGraph(value: progAverage, color: hsbShadeTint(color: colorTheme, sat: 0.40), rMax: 120, rMin: 90, trackSat: colorTheme.hsba.saturation)
    }
    
    @objc func resetNestedGraph() {
//        print("nestedTapped")
        
        singleCircleTitle.setTitleColor(.lightGray, for: .normal)
        singleCircleTitle.titleLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 14)
        nestedCircleTitle.setTitleColor(.gray, for: .normal)
        nestedCircleTitle.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        singleCircleTitle.sizeToFit()
        nestedCircleTitle.sizeToFit()
        
        homeProgressGraph.wipe()
        homeProgressGraph.drawNestedGraph(exerciseNum: (numOfEx < 2) ? 2 : numOfEx, exerciseNames: exerciseNames, values: progress, clr: colorTheme, rMax: 100, rMin: 20, trackSat: [5, 1], progSat: [50, 20], sweepAngle: CGFloat.pi/3)
    }
    
    func findPoint(center: CGPoint, color: UIColor) {
        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0.1
        self.view.layer.addSublayer(shapeLayer)
    }
}
