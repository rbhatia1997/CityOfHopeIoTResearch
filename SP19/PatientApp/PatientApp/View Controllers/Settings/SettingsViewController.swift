//
//  ExerciseSettingsViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 4/10/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let headerView = Header()
    private let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray.hsbBrt(0.9)

        setupViews()
        setupConstraints()
    }
    
    @objc func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHomeVCfromSettingsVC", sender: sender)
    }
}

extension SettingsViewController: ViewConstraintProtocol {
    func setupViews() {
        headerView.updateHeader(text: "Settings", color: .white, fsize: 30)
        self.view.addSubview(headerView)
        
        backButton.setButtonParams(color: .gray, string: "Back", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        // add back button constraints
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
    }
}
