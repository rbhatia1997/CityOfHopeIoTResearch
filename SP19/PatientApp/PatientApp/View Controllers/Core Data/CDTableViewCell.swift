//
//  CDTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/25/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

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
        dateLabel.setLabelParams(color: .gray, string: dateString, ftype: defFont, fsize: 12, align: .left)
        data0Label.setLabelParams(color: .gray, string: data0String, ftype: defFont, fsize: 16, align: .left)
        data1Label.setLabelParams(color: .gray, string: data1String, ftype: defFont, fsize: 16, align: .left)
        data2Label.setLabelParams(color: .gray, string: data2String, ftype: defFont, fsize: 16, align: .left)
        
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
