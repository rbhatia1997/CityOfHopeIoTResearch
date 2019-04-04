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
    private let serviceLabel = UILabel()
    private let uuidLabel = UILabel()
    
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
        statusLabel.setLabelParams(color: .black, string: "Device Status :  ", ftype: "Montserrat-Light",
                                   fsize: 14, align: .center)
        
        connectLabel.setLabelParams(color: .black, string: didConnect ? "Connected" : "Disconnected",
                                    ftype: "Montserrat-Regular", fsize: 14, align: .center)
        
        serviceLabel.setLabelParams(color: .black, string: "Service UUID :  ",
                                    ftype: "Montserrat-Light", fsize: 14, align: .center)
        
        uuidLabel.setLabelParams(color: .black, string: didConnect ? serviceString : "N/A",
                                 ftype: "Montserrat-Regular", fsize: 14, align: .center)
        
        self.addSubview(statusLabel)
        self.addSubview(connectLabel)
        self.addSubview(serviceLabel)
        self.addSubview(uuidLabel)
    }
    
    private func setupConstraints() {
        serviceLabel.translatesAutoresizingMaskIntoConstraints = false
        serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        serviceLabel.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        uuidLabel.translatesAutoresizingMaskIntoConstraints = false
        uuidLabel.leadingAnchor.constraint(equalTo: serviceLabel.trailingAnchor).isActive = true
        uuidLabel.centerYAnchor.constraint(equalTo: serviceLabel.centerYAnchor).isActive = true
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.leadingAnchor.constraint(equalTo: serviceLabel.leadingAnchor).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: serviceLabel.topAnchor).isActive = true
        
        connectLabel.translatesAutoresizingMaskIntoConstraints = false
        connectLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor).isActive = true
        connectLabel.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor).isActive = true
    }
    
    func updateBTStatus(connStat: Bool, uuidString: String) {
        didConnect = connStat
        serviceString = uuidString
        setupViews()
        setupConstraints()
    }
    
}
