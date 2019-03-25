//
//  CDTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/25/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class CDExerciseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CDGoalTableViewCell: UITableViewCell {
    var goalString: String!
    var achieveString: String!
    var dateString: String!
    
    private let goalLabel = UILabel()
    private let achieveLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let cellView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAll() {
        goalLabel.setLabelParams(color: .gray, string: goalString, ftype: "Montserrat-Regular", fsize: 16, align: .left)
        achieveLabel.setLabelParams(color: .gray, string: achieveString, ftype: "Montserrat-Regular", fsize: 12, align: .left)
        dateLabel.setLabelParams(color: .gray, string: dateString, ftype: "Montserrat-Regular", fsize: 12, align: .left)
        
        self.addSubview(goalLabel)
        self.addSubview(achieveLabel)
        self.addSubview(dateLabel)
        
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        goalLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        goalLabel.heightAnchor.constraint(equalToConstant: goalLabel.frame.height).isActive = true
        goalLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        goalLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        achieveLabel.translatesAutoresizingMaskIntoConstraints = false
        achieveLabel.topAnchor.constraint(equalTo: goalLabel.bottomAnchor).isActive = true
        achieveLabel.heightAnchor.constraint(equalToConstant: achieveLabel.frame.height).isActive = true
        achieveLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        achieveLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: goalLabel.bottomAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: dateLabel.frame.height).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        //        self.layoutIfNeeded()
        //        showBorder(view: goalLabel)
        //        showBorder(view: achieveLabel)
        //        showBorder(view: dateLabel)
    }
    
    func updateCell(goal: String, achieve: String, date: String) {
        goalString = goal
        achieveString = achieve
        dateString = date
        setupAll()
    }
}

class CDWellnessTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
