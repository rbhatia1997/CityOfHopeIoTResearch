//
//  ProgressTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {
    
    var name: String!

    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgressCell(name n: String) {
        name = n
        setupViews()
        setupConstraints()
    }
}

extension ProgressTableViewCell: ViewConstraintProtocol {
    func setupViews() {
        nameLabel.setLabelParams(color: .gray, string: name, ftype: defFont, fsize: 16, align: .left)
        self.addSubview(nameLabel)
    }
    
    func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.frame.height).isActive = true
    }
}
