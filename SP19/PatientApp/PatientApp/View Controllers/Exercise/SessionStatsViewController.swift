//
//  SessionStatsViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 4/16/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class SessionStatsViewController: UIViewController {
    
    private let colorTheme = UIColor(named: "green")!
    
    var sessionMeta = Meta()
    
    private let headerView = Header()
    private let backButton = UIButton()
    private let sessionLabel = UILabel()
    
    private var statArray = [MetricView]()
    private var baseArray = [MetricView]()
    private let numStats = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }
}

extension SessionStatsViewController {
    @objc func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toExerciseVCfromSessionVC", sender: sender)
    }
}

extension SessionStatsViewController: ViewConstraintProtocol {
    func setupViews() {
        headerView.updateHeader(text: "Last Session Stats", color: colorTheme.hsbSat(0.40), fsize: 30)
        self.view.addSubview(headerView)
        
        backButton.setButtonParams(color: .gray, string: "Back", ftype: defFont, fsize: 16, align: .center)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        let date = convertFormatFromID(id: sessionMeta.id, format: "MMMM dd, yyyy 'at' h:mm a")
        
        sessionLabel.setLabelParams(color: .gray, string: "Session: \(date)", ftype: defFont, fsize: 16, align: .left)
        self.view.addSubview(sessionLabel)
        
        for i in 0..<numStats {
            statArray.append(MetricView())
            self.view.addSubview(statArray[i])
            baseArray.append(MetricView())
            self.view.addSubview(baseArray[i])
        }
        
        statArray[0].updateView(top: "You were able to sweep", metric: "75º", bottom: "with your arm") // rom
        statArray[1].updateView(top: "You did a whole", metric: "10 reps", bottom: "just now") // reps
        statArray[2].updateView(top: "You were standing tall for", metric: "93%", bottom: "of the session")
        statArray[3].updateView(top: "You have the strength of", metric: "12 ducks", bottom: "")
        
        baseArray[0].updateView(top: "You are", metric: "12%", bottom: "more flexible")
        baseArray[1].updateView(top: "You did", metric: "3 reps", bottom: "more than last session")
        baseArray[2].updateView(top: "Your posture is", metric: "99%", bottom: "of your baseline posture")
        baseArray[3].updateView(top: "You can overpower", metric: "4 ducks", bottom: "more than last session")
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        
        sessionLabel.translatesAutoresizingMaskIntoConstraints = false
        sessionLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        sessionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        sessionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        statArray[0].translatesAutoresizingMaskIntoConstraints = false
        statArray[0].topAnchor.constraint(equalTo: sessionLabel.bottomAnchor, constant: 20).isActive = true
        statArray[0].leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        statArray[0].trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10).isActive = true
        
        for i in 1..<statArray.count {
            statArray[i].translatesAutoresizingMaskIntoConstraints = false
            statArray[i].centerXAnchor.constraint(equalTo: statArray[0].centerXAnchor).isActive = true
            statArray[i].widthAnchor.constraint(equalTo: statArray[0].widthAnchor).isActive = true
            statArray[i].topAnchor.constraint(equalTo: statArray[i-1].bottomAnchor, constant: 20).isActive = true
            statArray[i].heightAnchor.constraint(equalTo: statArray[0].heightAnchor).isActive = true
        }
        
        statArray[statArray.count-1].bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
        baseArray[0].translatesAutoresizingMaskIntoConstraints = false
        baseArray[0].topAnchor.constraint(equalTo: sessionLabel.bottomAnchor, constant: 20).isActive = true
        baseArray[0].leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10).isActive = true
        baseArray[0].trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        for i in 1..<baseArray.count {
            baseArray[i].translatesAutoresizingMaskIntoConstraints = false
            baseArray[i].centerXAnchor.constraint(equalTo: baseArray[0].centerXAnchor).isActive = true
            baseArray[i].widthAnchor.constraint(equalTo: baseArray[0].widthAnchor).isActive = true
            baseArray[i].topAnchor.constraint(equalTo: baseArray[i-1].bottomAnchor, constant: 20).isActive = true
            baseArray[i].heightAnchor.constraint(equalTo: baseArray[0].heightAnchor).isActive = true
        }
        
        baseArray[baseArray.count-1].bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
//        self.view.layoutIfNeeded()
//        for i in 0..<4 {
//            showBorder(view: statArray[i])
//            showBorder(view: baseArray[i])
//        }
    }
}
