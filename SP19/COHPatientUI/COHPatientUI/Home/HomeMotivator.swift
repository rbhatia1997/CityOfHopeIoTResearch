//
//  HomeMotivator.swift
//  COHPatientUI
//
//  Created by Darien Joso on 3/1/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class HomeMotivator: UIView {

//    override func draw(_ rect: CGRect) {}
    
    func listGoals(numDisplayGoals: Int, goals: [String]) {
        
        let titleYOffset: CGFloat = 0
        
        let goalYOffset: CGFloat = titleYOffset + 40
        
        let goalTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        goalTitle.font = UIFont(name: "Montserrat-Regular", size: 14)
        goalTitle.textColor = .gray
        goalTitle.text = "Your Top \(numDisplayGoals) Goals"
        goalTitle.sizeToFit()
        goalTitle.textAlignment = .center
        goalTitle.center.x = self.frame.width/2
        goalTitle.center.y = titleYOffset
        self.addSubview(goalTitle)
        
        for i in 0..<numDisplayGoals {
            let goalLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            goalLabel.font = UIFont(name: "Montserrat-Light", size: 18)
            goalLabel.textColor = .black
            goalLabel.text = "\(i+1). \(goals[i])"
            goalLabel.sizeToFit()
            goalLabel.textAlignment = .center
            goalLabel.center.x = goalLabel.frame.width/2
            goalLabel.center.y = goalYOffset + CGFloat((self.frame.height - goalYOffset) * CGFloat(i)) / CGFloat(numDisplayGoals)
            self.addSubview(goalLabel)
        }
        
    }
    
    func matchBackground(color: UIColor) {
         self.backgroundColor = color
    }

}
