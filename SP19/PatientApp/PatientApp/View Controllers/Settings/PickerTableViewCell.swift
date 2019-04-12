//
//  ExercisePickerTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 4/11/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {
    
    var name: String!
    var icon: UIImage!
    var use: Bool!
    var pickerCellDelegate: PickerTableViewCellDelegate?
    
    private let iconView = UIImageView()
    private let nameLabel = UILabel()
    let useButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePickerCell(name: String, icon: UIImage, use: Bool) {
        self.name = name
        self.icon = icon
        self.use = use
        setupViews()
        setupConstraints()
    }
}

extension PickerTableViewCell: ViewConstraintProtocol {
    func setupViews() {
        iconView.frame = .zero
        iconView.image = icon
        self.addSubview(iconView)
        
        nameLabel.setLabelParams(color: .gray, string: name, ftype: "Montserrat-Regular", fsize: 16, align: .left)
        self.addSubview(nameLabel)
        
        useButton.setButtonParams(color: use ? .gray : .white, string: "use: \(use!)", ftype: "Montserrat-Regular", fsize: 14, align: .center)
        useButton.titleLabel?.numberOfLines = 2
        useButton.setButtonFrame(borderWidth: 1.0, borderColor: use ? .white : .gray, cornerRadius: useButton.frame.height/2, fillColor: use ? .white : .gray, inset: 5)
        useButton.addTarget(self, action: #selector(useButtonTapped), for: .touchUpInside)
        self.addSubview(useButton)
    }
    
    func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor, multiplier: 9/16).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 5).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        useButton.translatesAutoresizingMaskIntoConstraints = false
        useButton.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        useButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5).isActive = true
        useButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}

extension PickerTableViewCell {
    @objc func useButtonTapped(_ sender: UIButton) {
        pickerCellDelegate?.useButtonPressed(sender.tag)
    }
}
