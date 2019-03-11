//
//  HomeViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // Subviews
    let headerView = Header(title: "Hello, Jane", color: UIColor(named: "blue")!)
    let goalList = HomeMotivator(goals: ["Cook for my kids",
                                         "Put on makeup by myself",
                                         "Tie up my hair",
                                         "Shower by myself",
                                         "Drive myself to work"])
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
        circleGraph.colorTheme = UIColor(named: "blue")!
        circleGraph.numberOfExercises = 3
        circleGraph.exerciseNames = ["Exercise 1", "Exercise 2", "Exercise 3", "Exercise 4",
                                     "Exercise 5", "Exercise 6", "Exercise 7", "Exercise 8"]
        circleGraph.exerciseValues = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8]
        
        for i in 0..<circleGraph.numberOfExercises {
            circleGraph.progressAverage += circleGraph.exerciseValues[i]
        }
        circleGraph.progressAverage /= CGFloat(circleGraph.numberOfExercises)
        circleGraph.darkestSaturation = 0.40
        circleGraph.updateProgressGraph()
    }
    
    private func addViews() {
        self.view.addSubview(headerView)
        self.view.addSubview(goalList)
        self.view.addSubview(circleGraph)
        self.view.addSubview(BTView)
    }
    
    private func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        goalList.translatesAutoresizingMaskIntoConstraints = false
        circleGraph.translatesAutoresizingMaskIntoConstraints = false
        BTView.translatesAutoresizingMaskIntoConstraints = false
        
        // Vertical Constraints
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        goalList.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        goalList.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/5).isActive = true
        circleGraph.topAnchor.constraint(equalTo: goalList.bottomAnchor, constant: 20).isActive = true
        circleGraph.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 2/5).isActive = true
        BTView.topAnchor.constraint(equalTo: circleGraph.bottomAnchor, constant: 20).isActive = true
        BTView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/20).isActive = true
        
        // Horizontal Constraints
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        goalList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        goalList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        circleGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        circleGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        BTView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        BTView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
}
