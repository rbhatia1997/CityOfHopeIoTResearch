//
//  BTConn.swift
//  PatientApp
//
//  Created by Darien Joso on 3/6/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class BTConn: UIView {
    
    // public variables
    public var didConnect: Bool!
    public var serviceString: String!
    
    // construction variables
    private let statusLabel = UILabel()
    private let connectLabel = UILabel()
    private let deviceLabel = UILabel()
    private let deviceNameLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    init(didConnect: Bool, serviceUUID: String) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.didConnect = didConnect
        serviceString = serviceUUID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        statusLabel.setLabelParams(color: .black, string: "Device Status :  ", ftype: defFontLight,
                                   fsize: 14, align: .center)
        
        connectLabel.setLabelParams(color: .black, string: didConnect ? "Connected" : "Disconnected",
                                    ftype: defFont, fsize: 14, align: .center)
        
        deviceLabel.setLabelParams(color: .black, string: "Device Name :  ",
                                    ftype: defFontLight, fsize: 14, align: .center)
        
        deviceNameLabel.setLabelParams(color: .black, string: didConnect ? serviceString : "N/A",
                                 ftype: defFont, fsize: 14, align: .center)
        
        self.addSubview(statusLabel)
        self.addSubview(connectLabel)
        self.addSubview(deviceLabel)
        self.addSubview(deviceNameLabel)
    }
    
    private func setupConstraints() {
        deviceLabel.translatesAutoresizingMaskIntoConstraints = false
        deviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        deviceLabel.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        deviceNameLabel.leadingAnchor.constraint(equalTo: deviceLabel.trailingAnchor).isActive = true
        deviceNameLabel.centerYAnchor.constraint(equalTo: deviceLabel.centerYAnchor).isActive = true
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.leadingAnchor.constraint(equalTo: deviceLabel.leadingAnchor).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: deviceLabel.topAnchor).isActive = true
        
        connectLabel.translatesAutoresizingMaskIntoConstraints = false
        connectLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor).isActive = true
        connectLabel.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor).isActive = true
    }
    
    func updateBTStatus(connStat: Bool, deviceString: String) {
        didConnect = connStat
        serviceString = deviceString
        setupViews()
        setupConstraints()
    }
}
