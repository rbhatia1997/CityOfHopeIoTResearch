//
//  BTConn.swift
//  PatientApp
//
//  Created by Darien Joso on 3/6/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class BTConn: UIView {
    
    let statusLabel = UILabel()
    let connectLabel = UILabel()
    let serviceLabel = UILabel()
    let uuidLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .lightGray
    }
    
    init(didConnect: Bool, serviceUUID: String) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        setupViews(didConnect, serviceUUID)
        addViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubview(statusLabel)
        self.addSubview(connectLabel)
        self.addSubview(serviceLabel)
        self.addSubview(uuidLabel)
    }
    
    private func setupViews(_ didConnect: Bool, _ serviceUUID: String) {
        statusLabel.frame = .zero
        statusLabel.font = UIFont(name: "Montserrat-Light", size: 14)
        statusLabel.textColor = .black
        statusLabel.text = "Device Status :  "
        statusLabel.sizeToFit()
        statusLabel.textAlignment = .center
        
        connectLabel.frame = .zero
        connectLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        connectLabel.textColor = .black
        connectLabel.text = didConnect ? "Connected" : "Disconnected"
        connectLabel.sizeToFit()
        connectLabel.textAlignment = .center
        
        serviceLabel.frame = .zero
        serviceLabel.font = UIFont(name: "Montserrat-Light", size: 14)
        serviceLabel.textColor = .black
        serviceLabel.text = "Service UUID :  "
        serviceLabel.sizeToFit()
        serviceLabel.textAlignment = .center
        
        uuidLabel.frame = .zero
        uuidLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        uuidLabel.textColor = .black
        uuidLabel.text = didConnect ? serviceUUID : "N/A"
        uuidLabel.sizeToFit()
        uuidLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        connectLabel.translatesAutoresizingMaskIntoConstraints = false
        serviceLabel.translatesAutoresizingMaskIntoConstraints = false
        uuidLabel.translatesAutoresizingMaskIntoConstraints = false
        
        serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        serviceLabel.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        uuidLabel.leadingAnchor.constraint(equalTo: serviceLabel.trailingAnchor).isActive = true
        uuidLabel.centerYAnchor.constraint(equalTo: serviceLabel.centerYAnchor).isActive = true
        
        statusLabel.leadingAnchor.constraint(equalTo: serviceLabel.leadingAnchor).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: serviceLabel.topAnchor).isActive = true
        connectLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor).isActive = true
        connectLabel.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor).isActive = true
    }
    
}
