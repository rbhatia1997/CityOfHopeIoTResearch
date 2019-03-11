//
//  ProgressViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

    let headerView = Header(title: "Progress", color: UIColor(named: "green")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addViews()
        setupConstraints()
    }
    
    private func setupViews() {
        
    }
    
    private func addViews() {
        self.view.addSubview(headerView)
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
    }
}
