//
//  HomeViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // load these variables with core data
    var goals = [String]()
    var exerciseValues = [CGFloat]()
    var exerciseNames = [String]()
    var BTDidConnect = Bool()
    var serviceUUID = String()
    
    // private variables
    private let colorTheme = UIColor(named: "blue")!
    private let BTtest: Bool = true
    private let CDtest: Bool = true

    // subviews
    private let headerView = Header()
    private let goalList = HomeMotivator()
    private let circleGraph = SimpleProgressGraph()
    private let BTView = BTConn()
    
    // construction variables
    let BTButton = UIButton()
    let CDButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the tab bar item title and image
        self.tabBarItem.selectedImage = UIImage(named: "home")!
        self.tabBarItem.title = "Home"
        
        // temporarily loading these variables manually
        goals = ["Cook for my kids",
                 "Put on makeup by myself",
                 "Tie up my hair",
                 "Shower by myself",
                 "Drive myself to work"]
        exerciseValues = [0.60, 0.90, 0.30, 0.40, 0.50]
        exerciseNames = ["Front Arm Raise",
                         "Side Arm Raise",
                         "Medicine Ball Overhead Circles",
                         "Arnold Shoulder Press",
                         "Dumbell Shoulder Press"]
        BTDidConnect = true
        serviceUUID = "6969"
        
        // run everything
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        // update all of the views
        headerView.updateHeader(text: "Hello, Jane", color: colorTheme, fsize: 30)
        circleGraph.updateProgressGraph(color: colorTheme, exNum: 2, exVal: exerciseValues, exName: exerciseNames)
        goalList.updateGoals(goalList: goals)
        BTView.updateBTStatus(connStat: BTDidConnect, uuidString: serviceUUID)
        
        // add the subviews to the main view
        self.view.addSubview(headerView)
        self.view.addSubview(goalList)
        self.view.addSubview(circleGraph)
        self.view.addSubview(BTView)
        
        // if needed for testing, include the BT tab
        if BTtest {
            BTButton.setButtonParams(color: .gray, string: "BT", ftype: "Montserrat-Regular", fsize: 16, align: .center)
            BTButton.addTarget(self, action: #selector(BTButtonPressed), for: .touchUpInside)
            self.view.addSubview(BTButton)
        }
        
        // if needed for testing, include the CD tab
        if CDtest {
            CDButton.setButtonParams(color: .gray, string: "CD", ftype: "Montserrat-Regular", fsize: 16, align: .center)
            CDButton.addTarget(self, action: #selector(CDButtonPressed), for: .touchUpInside)
            self.view.addSubview(CDButton)
        }
    }
    
    private func setupConstraints() {
        // set the header view constraints
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // set the goal list view constraints
        goalList.translatesAutoresizingMaskIntoConstraints = false
        goalList.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        goalList.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 4/20).isActive = true
        goalList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        goalList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // set the circular graph view constraints
        circleGraph.translatesAutoresizingMaskIntoConstraints = false
        circleGraph.topAnchor.constraint(equalTo: goalList.bottomAnchor, constant: 20).isActive = true
        circleGraph.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 8/20).isActive = true
        circleGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        circleGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // set the BT connection status view constraints
        BTView.translatesAutoresizingMaskIntoConstraints = false
        BTView.topAnchor.constraint(equalTo: circleGraph.bottomAnchor, constant: -10).isActive = true
        BTView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/20).isActive = true
        BTView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        BTView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // if needed for testing, add the BT button constraints
        if BTtest {
            BTButton.translatesAutoresizingMaskIntoConstraints = false
            BTButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
            BTButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            BTButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
            BTButton.widthAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        }
        
        if CDtest {
            CDButton.translatesAutoresizingMaskIntoConstraints = false
            CDButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
            CDButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            CDButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
            CDButton.widthAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        }
    }
    
    // sends the user to the BT testing page
    @objc func BTButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toBluetoothVC", sender: sender)
    }
    
    @objc func CDButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toCoreDataVC", sender: sender)
    }
    
    // brings the user back to the home VC
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {}
}
