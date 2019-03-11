//
//  HomeMotivator.swift
//  PatientApp
//
//  Created by Darien Joso on 3/6/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class HomeMotivator: UIView {
    
    private let goalTitle = UILabel()
    private var goalList = [UILabel]()
    private let goalNum: Int = 5
    private let stackGoals = UIStackView()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .yellow
    }

    init(goals: [String]) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        setupViews(goalNum, goals)
        addViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubview(goalTitle)
        self.addSubview(stackGoals)
    }
    
    private func setupViews(_ goalNum: Int,_ goals: [String]) {
        goalTitle.frame = .zero
        goalTitle.font = UIFont(name: "Montserrat-Regular", size: 14)
        goalTitle.textColor = .gray
        goalTitle.text = "Your Top \(goalNum) Goals"
        goalTitle.sizeToFit()
        goalTitle.textAlignment = .center
        
        for i in 0..<goalNum {
            goalList.append(UILabel())
            
            goalList[i].frame = .zero
            goalList[i].font = UIFont(name: "Montserrat-Light", size: 18)
            goalList[i].textColor = .black
            goalList[i].text = "\(i+1). \(goals[i])"
            goalList[i].sizeToFit()
            goalList[i].textAlignment = .left
            
            stackGoals.insertArrangedSubview(goalList[i], at: i)
        }
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    
    
}
