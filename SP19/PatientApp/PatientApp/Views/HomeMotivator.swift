//
//  HomeMotivator.swift
//  PatientApp
//
//  Created by Darien Joso on 3/6/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class HomeMotivator: UIView {
    
    // public variables
    public var goals: [String]!
    
    // construction variables
    private let goalTitle = UILabel()
    private var goalList = [UILabel]()
    private var goalNum: Int = 5
    private let stackGoals = UIStackView()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }

    init(goals: [String]) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.goals = goals
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        if goals.count < goalNum {
            goalNum = goals.count
        }
        
        goalTitle.setLabelParams(color: .gray, string: "Your Top \(goalNum) Goals",
            ftype: "Montserrat-Regular", fsize: 14, align: .center)
        
        for i in 0..<goalNum {
            goalList.append(UILabel())
            
            goalList[i].setLabelParams(color: .black, string: "\(i+1). \(goals[i])",
                ftype: "Montserrat-Light", fsize: 18, align: .left)
            
            stackGoals.insertArrangedSubview(goalList[i], at: i)
        }
        
        self.addSubview(goalTitle)
        self.addSubview(stackGoals)
    }
    
    private func setupConstraints() {
        goalTitle.translatesAutoresizingMaskIntoConstraints = false
        goalTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        goalTitle.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        goalTitle.widthAnchor.constraint(equalToConstant: goalTitle.frame.width).isActive = true
        goalTitle.heightAnchor.constraint(equalToConstant: goalTitle.frame.height).isActive = true
        
        stackGoals.translatesAutoresizingMaskIntoConstraints = false
        stackGoals.topAnchor.constraint(equalTo: goalTitle.bottomAnchor, constant: 5).isActive = true
        stackGoals.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackGoals.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackGoals.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        stackGoals.axis = .vertical
        stackGoals.distribution = .fillEqually
    }
    
    func updateGoals(goalList: [String]) {
        goals = goalList
        setupViews()
        setupConstraints()
    }
    
}
