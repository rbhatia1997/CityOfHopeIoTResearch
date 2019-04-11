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
        goalNum = goalNum > 5 ? 5 : goals.count
        
        goalTitle.setLabelParams(color: .gray, string: goalNum == 1 ? "Your Top \(goalNum) Goal" : "Your Top \(goalNum) Goals",
            ftype: "Montserrat-Regular", fsize: 14, align: .center)
        
        for i in 0..<goalNum {
            goalList.append(UILabel())
            
            goalList[i].setLabelParams(color: .black, string: "\(i+1). \(goals[i])",
                ftype: "Montserrat-Light", fsize: 18, align: .left, tag: 101)
            
            self.addSubview(goalList[i])
            
        }
        
        self.addSubview(goalTitle)
    }
    
    private func setupConstraints() {
        goalTitle.translatesAutoresizingMaskIntoConstraints = false
        goalTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        goalTitle.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        goalTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        goalTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        for i in 0..<goalNum {
            goalList[i].translatesAutoresizingMaskIntoConstraints = false
            goalList[i].topAnchor.constraint(equalTo: i==0 ? goalTitle.bottomAnchor : goalList[i-1].bottomAnchor, constant: 5).isActive = true
            goalList[i].centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            goalList[i].widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            goalList[i].heightAnchor.constraint(equalToConstant: 22).isActive = true
        }
    }
    
    func updateGoals(goalList: [String]) {
        for _ in self.goalList {
            if let goal = self.viewWithTag(101) {
                goal.removeFromSuperview()
            }
        }
        goals = goalList
        goalNum = goalNum > 5 ? 5 : goals.count
        setupViews()
        setupConstraints()
    }
    
}
