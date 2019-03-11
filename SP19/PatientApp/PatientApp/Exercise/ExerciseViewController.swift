//
//  ExerciseViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    let colorTheme = UIColor(named: "pink")!
    
    // Subviews
    let headerView = Header()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addViews()
        setupConstraints()
    }
    
    private func setupViews() {
        headerView.headerString = "Workouts"
        headerView.headerColor = colorTheme
        headerView.updateHeader()
    }
    
    private func addViews() {
        self.view.addSubview(headerView)
    }
    
    private func setupConstraints() {
        setupHeaderConstraints()
    }
    
    private func setupHeaderConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Vertical Constraints
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        // Horizontal Constraints
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
    }
}
