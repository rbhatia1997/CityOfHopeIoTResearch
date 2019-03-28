//
//  ProgressViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController, ViewConstraintProtocol {

    let colorTheme = UIColor(named: "green")!
    
    // Subviews
    let headerView = Header()
    let progressGraph = OverallProgressGraph()
    let exerciseProgressList = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.selectedImage = UIImage(named: "progress")!
        self.tabBarItem.title = "Progress"
        
        setupViews()
        setupConstraints()
        
        self.view.layoutIfNeeded()
        showBorder(view: progressGraph)
        showBorder(view: exerciseProgressList)
    }
    
    internal func setupViews() {
        headerView.updateHeader(text: "Progress", color: colorTheme, fsize: 30)
        
        self.view.addSubview(headerView)
        self.view.addSubview(progressGraph)
        self.view.addSubview(exerciseProgressList)
    }
    
    internal func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        progressGraph.translatesAutoresizingMaskIntoConstraints = false
        progressGraph.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        progressGraph.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        progressGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        progressGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        exerciseProgressList.translatesAutoresizingMaskIntoConstraints = false
        exerciseProgressList.topAnchor.constraint(equalTo: progressGraph.bottomAnchor, constant: 20).isActive = true
        exerciseProgressList.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        exerciseProgressList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        exerciseProgressList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
    
    @IBAction func unwindToProgressVC(segue: UIStoryboardSegue) {}
}
