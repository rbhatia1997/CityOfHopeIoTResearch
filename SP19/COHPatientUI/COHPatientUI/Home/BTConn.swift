//
//  BTConn.swift
//  COHPatientUI
//
//  Created by Darien Joso on 3/1/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class BTConn: UIView {

//    override func draw(_ rect: CGRect) {}
    
    func printConnection(didConnect: Bool, serviceUUID: String) {
        
        let connectString: String
        let uuidString: String
        
        if didConnect {
            connectString = "Connected"
            uuidString = serviceUUID
        } else {
            connectString = "Disconnected"
            uuidString = "N/A"
        }
        
        let serviceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        serviceLabel.font = UIFont(name: "Montserrat-Thin", size: 14)
        serviceLabel.textColor = .black
        serviceLabel.text = "Service UUID :  "
        serviceLabel.sizeToFit()
        serviceLabel.textAlignment = .center
        
        let uuidLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        uuidLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        uuidLabel.textColor = .black
        uuidLabel.text = "\(uuidString)"
        uuidLabel.sizeToFit()
        uuidLabel.textAlignment = .center
        
        let statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        statusLabel.font = UIFont(name: "Montserrat-Thin", size: 14)
        statusLabel.textColor = .black
        statusLabel.text = "Device Status :  "
        statusLabel.sizeToFit()
        statusLabel.textAlignment = .center
        
        let connectLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        connectLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        connectLabel.textColor = .black
        connectLabel.text = "\(connectString)"
        connectLabel.sizeToFit()
        connectLabel.textAlignment = .center
        
        serviceLabel.center.x = self.frame.width/2 - abs(serviceLabel.frame.width/2 - (serviceLabel.frame.width - uuidLabel.frame.width))
        serviceLabel.center.y = self.frame.height/2 + serviceLabel.frame.height/2
        
        uuidLabel.center.x = serviceLabel.center.x + serviceLabel.frame.width/2 + uuidLabel.frame.width/2
        uuidLabel.center.y = serviceLabel.center.y
        
        statusLabel.center.x = serviceLabel.center.x - (serviceLabel.frame.width - statusLabel.frame.width)/2
        statusLabel.center.y = self.frame.height/2 - statusLabel.frame.height/2
        
        connectLabel.center.x = statusLabel.center.x + statusLabel.frame.width/2 + connectLabel.frame.width/2
//        uuidLabel.center.x - (uuidLabel.frame.width - connectLabel.frame.width)/2
//        statusLabel.center.x + statusLabel.frame.width/2 + connectLabel.frame.width/2
        connectLabel.center.y = statusLabel.center.y
        
        self.addSubview(serviceLabel)
        self.addSubview(uuidLabel)
        self.addSubview(statusLabel)
        self.addSubview(connectLabel)
        
//        let box = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
//        let boxPath = UIBezierPath(rect: box)
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = boxPath.cgPath
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = UIColor.clear.cgColor
//        shapeLayer.lineWidth = 1.0
//
//        self.layer.addSublayer(shapeLayer)
    }
    
    func matchBackground(color: UIColor) {
        self.backgroundColor = color
    }

}
