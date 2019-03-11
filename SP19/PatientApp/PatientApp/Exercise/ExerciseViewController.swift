//
//  ExerciseViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {

    let headerView = Header(title: "Workouts", color: UIColor(named: "pink")!)
    
    private let tempView = SimpleProgressGraph(color: UIColor(named: "blue")!,
                                               exNames: ["Exercise 1", "Exercise 2", "Exercise 3", "Exercise 4", "Exercise 5", "Exercise 6", "Exercise 7", "Exercise 8"],
                                               exValues: [0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75],
                                               darkestSat: 0.40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addViews()
        setupConstraints()
        
        self.view.layoutIfNeeded()
        findPoint(center: CGPoint(x: tempView.frame.width/2, y: tempView.frame.height/2), color: .red, view: tempView)
        findPoint(center: CGPoint(x: tempView.frame.width/2, y: tempView.frame.height/2), color: .blue, view: self.view)
        
    }
    
    private func setupViews() {
        
    }
    
    private func addViews() {
        self.view.addSubview(headerView)
        self.view.addSubview(tempView)
    }
    
    private func setupConstraints() {
        setupHeaderConstraints()
    }
    
    private func setupHeaderConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tempView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tempView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tempView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        tempView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        tempView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        tempView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}
