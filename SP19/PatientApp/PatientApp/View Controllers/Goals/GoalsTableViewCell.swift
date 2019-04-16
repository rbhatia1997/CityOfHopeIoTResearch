//
//  GoalsTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/25/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class GoalsTableViewCell: UITableViewCell {

    var number = Int()
    var goalString: String!
    var achieved: Bool!
    var goalCellDelegate: GoalsTableViewCellDelegate?
    
    private let numberLabel = UILabel()
    private let goalLabel = UILabel()
    let doneButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateGoalCell(number: Int, goal: String, isDone: Bool) {
        self.number = number
        goalString = goal
        achieved = isDone
        setupViews()
        setupConstraints()
    }
}

// MARK: button actions
extension GoalsTableViewCell {
    @objc func tapCompleteButton(_ sender: UIButton) {
        goalCellDelegate?.doneButtonPressed(sender.tag)
    }
}

// MARK: create UI
extension GoalsTableViewCell: ViewConstraintProtocol {
    internal func setupViews() {
        numberLabel.setLabelParams(color: .black, string: "\(number).", ftype: defFont, fsize: 16, align: .left)
        self.addSubview(numberLabel)
        
        goalLabel.setLabelParams(color: .black, string: goalString, ftype: defFont, fsize: 16, align: .left)
        self.addSubview(goalLabel)
        
        doneButton.setButtonParams(color: .gray, string: achieved ? "Complete: ✅" : "Complete: ❌", ftype: defFont, fsize: 12, align: .center)
        doneButton.setButtonFrame(borderWidth: 1.0, borderColor: .gray, cornerRadius: doneButton.frame.height/2, fillColor: .clear, inset: 5)
        doneButton.addTarget(self, action: #selector(tapCompleteButton), for: .touchUpInside)
        self.addSubview(doneButton)
    }
    
    internal func setupConstraints() {
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        numberLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        goalLabel.topAnchor.constraint(equalTo: numberLabel.topAnchor).isActive = true
        goalLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        goalLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor).isActive = true
        goalLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -120).isActive = true
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerYAnchor.constraint(equalTo: goalLabel.centerYAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: doneButton.frame.height).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
