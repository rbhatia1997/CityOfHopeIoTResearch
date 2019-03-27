//
//  ExerciseGuideViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class ExerciseGuideViewController: UIViewController, ViewConstraintProtocol {
    
    // global variables
    var colorTheme: UIColor!
    var exerciseName: String!
    var exerciseImage: UIImage!
    
    // subviews
    var activeGraph = SweepGraph()
    
    // construction variables
    private let backButton = UIButton()
    private let exLabel = UILabel()
    private let exImageView = UIImageView()
    private let instrLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        // call for placement purposes
//        self.view.layoutIfNeeded()
//        showBorder(view: backButton)
//        showBorder(view: exLabel)
//        showBorder(view: exImageView)
//        showBorder(view: instrLabel)
//        showBorder(view: activeGraph)
//        showBorder(view: startButton)
    }
    
    internal func setupViews() {
        // setup back button
        backButton.setButtonParams(color: .gray, string: "< Back", ftype: "Montserrat-Regular",
                                   fsize: 16, align: .center)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        // setup exercise label
        exLabel.setLabelParams(color: hsbShadeTint(color: colorTheme, sat: 0.40), string: exerciseName,
                               ftype: "Montserrat-ExtraLight", fsize: 24, align: .left)
        
        // setup image view
        exImageView.frame = .zero
        exImageView.image = exerciseImage
        
        // setup instruction label
        instrLabel.setLabelParams(color: .gray, string: "Instructions: Replace me with a proper description if needed",
                                  ftype: "Montserrat-Regular", fsize: 14, align: .left)

        // setup graph
        activeGraph.updateSweepGraph(color: colorTheme, start: degToRad(deg: 0), max: degToRad(deg: 150), right: true, value: degToRad(deg: 60))
        
        // add all subviews to the main view
        self.view.addSubview(backButton)
        self.view.addSubview(exLabel)
        self.view.addSubview(exImageView)
        self.view.addSubview(instrLabel)
        self.view.addSubview(activeGraph)
    }
    
    internal func setupConstraints() {
        // add back button constraints
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: backButton.frame.height).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: backButton.frame.width).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        
        // add exercise label constraints
        exLabel.translatesAutoresizingMaskIntoConstraints = false
        exLabel.centerYAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 35).isActive = true
        exLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        exLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // add exercise image constraints
        exImageView.translatesAutoresizingMaskIntoConstraints = false
        exImageView.topAnchor.constraint(equalTo: exLabel.centerYAnchor, constant: 35).isActive = true
        exImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        exImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        exImageView.widthAnchor.constraint(equalTo: exImageView.heightAnchor, multiplier: 16/9).isActive = true
        
        // add instruction label constraints
        instrLabel.translatesAutoresizingMaskIntoConstraints = false
        instrLabel.topAnchor.constraint(equalTo: exImageView.bottomAnchor, constant: 20).isActive = true
        instrLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        instrLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // add graph constraints
        activeGraph.translatesAutoresizingMaskIntoConstraints = false
        activeGraph.topAnchor.constraint(equalTo: instrLabel.bottomAnchor, constant: 20).isActive = true
        activeGraph.heightAnchor.constraint(equalToConstant: 370).isActive = true
        activeGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        activeGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
    
    // send user back to main exercise view controller if pressed
    @objc func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toExerciseVC", sender: sender)
    }

}
