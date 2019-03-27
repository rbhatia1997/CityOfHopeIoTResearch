//
//  CDTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/25/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

//class CDExerciseTableViewCell: UITableViewCell, ViewConstraintProtocol {
//    var nameString: String!
//    var dateString: String!
//
//    private let nameLabel = UILabel()
//    private let dateLabel = UILabel()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = .lightGray
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    internal func setupViews() {
//        nameLabel.setLabelParams(color: .gray, string: nameString, ftype: "Montserrat-Regular", fsize: 16, align: .left)
//        dateLabel.setLabelParams(color: .gray, string: dateString, ftype: "Montserrat-Regular", fsize: 12, align: .left)
//
//        self.addSubview(nameLabel)
//        self.addSubview(dateLabel)
//    }
//
//    internal func setupConstraints() {
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        nameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.frame.height).isActive = true
//        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//
//        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
//        dateLabel.heightAnchor.constraint(equalToConstant: dateLabel.frame.height).isActive = true
//        dateLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        dateLabel.trailingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//    }
//
//    func updateCell(name: String, date: String) {
//        nameString = name
//        dateString = date
//        setupViews()
//        setupConstraints()
//    }
//}
//
//class CDGoalTableViewCell: UITableViewCell, ViewConstraintProtocol {
//    var goalString: String!
//    var achieveString: String!
//    var dateString: String!
//
//    private let goalLabel = UILabel()
//    private let achieveLabel = UILabel()
//    private let dateLabel = UILabel()
//
//    private let cellView = UIView()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    internal func setupViews() {
//        goalLabel.setLabelParams(color: .gray, string: goalString, ftype: "Montserrat-Regular", fsize: 16, align: .left)
//        achieveLabel.setLabelParams(color: .gray, string: achieveString, ftype: "Montserrat-Regular", fsize: 12, align: .left)
//        dateLabel.setLabelParams(color: .gray, string: dateString, ftype: "Montserrat-Regular", fsize: 12, align: .left)
//
//        self.addSubview(goalLabel)
//        self.addSubview(achieveLabel)
//        self.addSubview(dateLabel)
//    }
//
//    internal func setupConstraints() {
//        goalLabel.translatesAutoresizingMaskIntoConstraints = false
//        goalLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        goalLabel.heightAnchor.constraint(equalToConstant: goalLabel.frame.height).isActive = true
//        goalLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        goalLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
//
//        achieveLabel.translatesAutoresizingMaskIntoConstraints = false
//        achieveLabel.topAnchor.constraint(equalTo: goalLabel.bottomAnchor).isActive = true
//        achieveLabel.heightAnchor.constraint(equalToConstant: achieveLabel.frame.height).isActive = true
//        achieveLabel.leadingAnchor.constraint(equalTo: goalLabel.leadingAnchor).isActive = true
//        achieveLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//
//        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        dateLabel.topAnchor.constraint(equalTo: goalLabel.bottomAnchor).isActive = true
//        dateLabel.heightAnchor.constraint(equalToConstant: dateLabel.frame.height).isActive = true
//        dateLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//
//        //        self.layoutIfNeeded()
//        //        showBorder(view: goalLabel)
//        //        showBorder(view: achieveLabel)
//        //        showBorder(view: dateLabel)
//    }
//
//    func updateCell(goal: String, achieve: String, date: String) {
//        goalString = goal
//        achieveString = achieve
//        dateString = date
//        setupViews()
//        setupConstraints()
//    }
//}

class CDTableViewCell: UITableViewCell, ViewConstraintProtocol {
    var dateString: String!
    var data0String: String!
    var data1String: String!
    var data2String: String!
    
    private let dateLabel = UILabel()
    private let data0Label = UILabel()
    private let data1Label = UILabel()
    private let data2Label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        dateLabel.setLabelParams(color: .gray, string: dateString, ftype: "Montserrat-Regular", fsize: 12, align: .left)
        data0Label.setLabelParams(color: .gray, string: data0String, ftype: "Montserrat-Regular", fsize: 16, align: .left)
        data1Label.setLabelParams(color: .gray, string: data1String, ftype: "Montserrat-Regular", fsize: 16, align: .left)
        data2Label.setLabelParams(color: .gray, string: data2String, ftype: "Montserrat-Regular", fsize: 16, align: .left)
        
        self.addSubview(dateLabel)
        self.addSubview(data0Label)
        self.addSubview(data1Label)
        self.addSubview(data2Label)
    }
    
    func setupConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        data0Label.translatesAutoresizingMaskIntoConstraints = false
        data0Label.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        data0Label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        data0Label.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        data0Label.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
        
        data1Label.translatesAutoresizingMaskIntoConstraints = false
        data1Label.topAnchor.constraint(equalTo: data0Label.bottomAnchor, constant: 5).isActive = true
        data1Label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        data1Label.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        data1Label.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
        
        data2Label.translatesAutoresizingMaskIntoConstraints = false
        data2Label.topAnchor.constraint(equalTo: data1Label.bottomAnchor, constant: 5).isActive = true
        data2Label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        data2Label.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        data2Label.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
    }
    
    func updateCell(date: String, data0: String, data1: String, data2: String) {
        dateString = date
        data0String = data0
        data1String = data1
        data2String = data2
        setupViews()
        setupConstraints()
    }
}
