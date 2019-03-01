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
    
    let numOfEx = 5
    var progress = [CGFloat]()
    var exerciseNames = [String]()
    let colorTheme: UIColor = UIColor(named: "blue") ?? .black // color sets must be [Extended Range sRGB] to work
    let uuid: String = "COH-AMT-1234"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<numOfEx {
            progress.append(CGFloat(Int.random(in: 0..<100)) / 100) // add random value between 0 and 2PI
            exerciseNames.append("Exercise \(i+1)")
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewLoadSetup()
    }
    
    func viewLoadSetup() {
        headerView.setHeader(text: "Hello, Jane", color: colorTheme)
        homeProgressGraph.wipe()
        homeProgressGraph.drawGraph(exerciseNum: (numOfEx < 2) ? 2 : numOfEx, exerciseNames: exerciseNames, values: progress, clr: colorTheme, rMax: 100, rMin: 20, trackSat: [5, 1], progSat: [50, 20], sweepAngle: CGFloat.pi/3)
        
        bluetoothConnection.printConnection(didConnect: true, serviceUUID: uuid)
    }
}
