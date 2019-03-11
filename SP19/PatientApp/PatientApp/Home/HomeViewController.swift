//
//  HomeViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let colorTheme = UIColor(named: "blue")!
    var exerciseNames: [String] = ["Front Arm Raise", "Side Arm Raise", "Exercise 3", "Exercise 4", "Exercise 5"]
    var exerciseValues: [CGFloat] = [0.60, 0.90, 0.3, 0.4, 0.5]
    
    // Subviews
    let headerView = Header()
    let goalList = HomeMotivator()
    let circleGraph = SimpleProgressGraph()
    let BTView = BTConn(didConnect: true, serviceUUID: "COH-AMT-1234")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.selectedImage = UIImage(named: "home")!
        self.tabBarItem.title = "Home"
        
        setupViews()
        addViews()
        setupConstraints()
    }
    
    private func setupViews() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.headerString = "Hello, Jane"
        headerView.headerColor = colorTheme
        headerView.updateHeader()
        
        circleGraph.translatesAutoresizingMaskIntoConstraints = false
        circleGraph.colorTheme = UIColor(named: "blue")!
        circleGraph.numberOfExercises = 2
        circleGraph.exerciseNames = exerciseNames
        circleGraph.exerciseValues = exerciseValues
        
        for i in 0..<circleGraph.numberOfExercises {
            circleGraph.progressAverage += circleGraph.exerciseValues[i]
        }
        circleGraph.progressAverage /= CGFloat(circleGraph.numberOfExercises)
        circleGraph.darkestSaturation = 0.40
        circleGraph.updateProgressGraph()
        
        goalList.translatesAutoresizingMaskIntoConstraints = false
        goalList.goals = ["Cook for my kids",
                          "Put on makeup by myself",
                          "Tie up my hair",
                          "Shower by myself",
                          "Drive myself to work"]
        goalList.updateGoals()
        
        BTView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addViews() {
        self.view.addSubview(headerView)
        self.view.addSubview(goalList)
        self.view.addSubview(circleGraph)
        self.view.addSubview(BTView)
    }
    
    private func setupConstraints() {
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        goalList.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        goalList.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/5).isActive = true
        goalList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        goalList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        circleGraph.topAnchor.constraint(equalTo: goalList.bottomAnchor, constant: 20).isActive = true
        circleGraph.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 2/5).isActive = true
        circleGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        circleGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        BTView.topAnchor.constraint(equalTo: circleGraph.bottomAnchor, constant: 20).isActive = true
        BTView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/20).isActive = true
        BTView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        BTView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
}
