//
//  GoalsTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/25/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class GoalsTableViewCell: UITableViewCell, ViewConstraintProtocol {

    var number = Int()
    var goalString: String!
    var achieved: Bool!
    var goalCellDelegate: GoalsTableViewCellDelegate?
    
    private let numberLabel = UILabel()
    private let goalLabel = UILabel()
    let doneButton = UIButton()
    private let cellView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func achievedButtonPressed(_ tag: Int) {
        achieved = !achieved
        updateGoalCell(number: number, goal: goalString, isDone: achieved)
    }
    
    internal func setupViews() {
        cellView.frame = .zero
        cellView.backgroundColor = .clear
        self.addSubview(cellView)
        
        numberLabel.setLabelParams(color: .black, string: "\(number).", ftype: "Montserrat-Regular", fsize: 16, align: .left)
        self.addSubview(numberLabel)
        
        goalLabel.setLabelParams(color: .black, string: goalString, ftype: "Montserrat-Regular", fsize: 16, align: .left)
        self.addSubview(goalLabel)
        
        doneButton.setButtonParams(color: .gray, string: achieved ? "Complete: ✅" : "Complete: ❌", ftype: "Montserrat-Regular", fsize: 12, align: .left)
        doneButton.addTarget(self, action: #selector(tapCompleteButton), for: .touchUpInside)
        self.addSubview(doneButton)
        
        let screen = CGRect(x: -5, y: 0, width: doneButton.frame.width + 10, height: doneButton.frame.height)
        let screenPath = UIBezierPath(roundedRect: screen, cornerRadius: 5)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = screenPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 1.0
        doneButton.layer.addSublayer(shapeLayer)
    }
    
    internal func setupConstraints() {
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //        cellView.heightAnchor.constraint(equalToConstant: goalLabel.frame.height + 20).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: numberLabel.frame.height).isActive = true
        numberLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        goalLabel.topAnchor.constraint(equalTo: numberLabel.topAnchor).isActive = true
        goalLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10).isActive = true
        goalLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor).isActive = true
        goalLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -110).isActive = true
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerYAnchor.constraint(equalTo: goalLabel.centerYAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: doneButton.frame.height).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 50)
    }
    
    func updateGoalCell(number: Int, goal: String, isDone: Bool) {
        self.number = number
        goalString = goal
        achieved = isDone
        setupViews()
        setupConstraints()
    }
    
    @objc func tapCompleteButton(_ sender: UIButton) {
        goalCellDelegate?.doneButtonPressed(sender.tag)
    }
}

protocol GoalsTableViewCellDelegate : AnyObject {
    func doneButtonPressed(_ tag: Int)
}
