//
//  BTViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class BTViewController: UIViewController {
    
    private let colorTheme: UIColor = hsbShadeTint(color: .blue, sat: 0.50)
    
    var serviceUUID = CBUUID(string: "2f391f0f-1c30-46fb-a972-a22c2f7570ee")
    var char0UUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
    
    let headerView = Header()
    let serviceTitle = UILabel()
    var serviceUUIDLabel = UILabel()
    let peripheralTitle = UILabel()
    var peripheralName = UILabel()
    
    let char0Title = UILabel()
    var char0Label = UILabel()
    let char0ValTitle = UILabel()
    var char0Val = UILabel()
    
    private let titleSize: CGFloat = 20
    private let valSize: CGFloat = 14
    
    var centralManager: CBCentralManager!
    var wearablePeripheral: CBPeripheral!
    
    let homeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: (self as CBCentralManagerDelegate), queue: nil, options: nil)
        
        setupViews()
        setupConstraints()
    }
}

extension BTViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [serviceUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        wearablePeripheral = peripheral
        wearablePeripheral.delegate = (self as CBPeripheralDelegate)
        centralManager.stopScan()
        centralManager.connect(wearablePeripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        print(peripheral.name ?? "not detected")
        wearablePeripheral.discoverServices([serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        serviceUUIDLabel.text = "--"
        peripheralName.text = "--"
        char0Label.text = "--"
        char0Val.text = "--"
        print("Disconnected... scanning for peripherals")
        centralManager.scanForPeripherals(withServices: [serviceUUID])
    }
}

extension BTViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        serviceUUIDLabel.text = serviceUUID.uuidString
        peripheralName.text = peripheral.name
        switch characteristic.uuid {
        case char0UUID:
            char0Label.text = characteristic.uuid.uuidString
            let data = characteristic.value!
            let farr: [Float] = dataToFloats(data: data, numFloats: 18)
            var roll = String()
            var pitch = String()
            var yaw = String()
            var s = ""
            if farr.count == 18 {
                s += "timestep: \(String(format: " %.3f", farr[16]))\n"
                for i in 0..<4 {
                    s += "q\(i): [\(String(format: " %.2f", farr[4*i])), \(String(format: " %.2f", farr[4*i+1])), \(String(format: " %.2f", farr[4*i+2])), \(String(format: " %.2f", farr[4*i+3]))]\n"
                    roll = String(format: "%.2f", 180/Float.pi*get_roll(q: [ farr[4*i], farr[4*i+1], farr[4*i+2], farr[4*i+3] ]))
                    pitch = String(format: "%.2f", 180/Float.pi*get_pitch(q: [ farr[4*i], farr[4*i+1], farr[4*i+2], farr[4*i+3] ]))
                    yaw = String(format: "%.2f", 180/Float.pi*get_yaw(q: [ farr[4*i], farr[4*i+1], farr[4*i+2], farr[4*i+3] ]))
                    s += "rpy\(i): [\(roll), \(pitch), \(yaw)] \n"
                }
                char0Val.text = s
            }
        default:
            serviceUUIDLabel.text = "No data"
            peripheralName.text = "No data"
        }
    }
}

extension BTViewController: ViewConstraintProtocol {
    internal func setupViews() {
        headerView.updateHeader(text: "Blutooth", color: hsbShadeTint(color: colorTheme, sat: 0.20), fsize: 30)
        self.view.addSubview(headerView)
        
        groupSetup(title1: serviceTitle, title1Val: serviceUUIDLabel, title1String: "Service UUID:",
                   title2: peripheralTitle, title2Val: peripheralName, title2String: "Peripheral Name:",
                   titleSize: titleSize, valSize: valSize)
        groupSetup(title1: char0Title, title1Val: char0Label, title1String: "Characteristic 0 UUID:",
                   title2: char0ValTitle, title2Val: char0Val, title2String: "Characteristic 0 Data:",
                   titleSize: titleSize, valSize: valSize)

        homeButton.setButtonParams(color: .gray, string: "Back", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        self.view.addSubview(homeButton)
    }
    
    internal func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        groupConstraints(topView: headerView, title1: serviceTitle, title1Val: serviceUUIDLabel,
                         title2: peripheralTitle, title2Val: peripheralName, titleSize: titleSize, valSize: valSize)
        drawRoundedRect(view: serviceTitle, origin: CGPoint(x: -10, y: -10), width: self.view.frame.width - 20, height: 110, corner: 5, color: colorTheme, strokeWidth: 1.0)
        
        groupConstraints(topView: peripheralName, title1: char0Title, title1Val: char0Label,
                         title2: char0ValTitle, title2Val: char0Val, titleSize: titleSize, valSize: valSize)
        drawRoundedRect(view: char0Title, origin: CGPoint(x: -10, y: -10), width: self.view.frame.width - 20, height: 280, corner: 5, color: colorTheme, strokeWidth: 1.0)
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        homeButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        homeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        homeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func homeButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHomeVCFromBTVC", sender: sender)
    }
    
    private func groupSetup(title1: UILabel, title1Val: UILabel, title1String: String, title2: UILabel, title2Val: UILabel, title2String: String, titleSize: CGFloat, valSize: CGFloat) {
        title1.setLabelParams(color: colorTheme, string: title1String, ftype: "Montserrat-Regular", fsize: titleSize, align: .left)
        title1Val.setLabelParams(color: .black, string: "--", ftype: "Montserrat-Regular", fsize: valSize, align: .left)
        self.view.addSubview(title1)
        self.view.addSubview(title1Val)
        
        title2.setLabelParams(color: colorTheme, string: title2String, ftype: "Montserrat-Regular", fsize: titleSize, align: .left)
        title2Val.setLabelParams(color: .black, string: "--", ftype: "Montserrat-Regular", fsize: valSize, align: .left)
        self.view.addSubview(title2)
        self.view.addSubview(title2Val)
    }
    
    private func groupConstraints(topView: UIView, title1: UIView, title1Val: UIView, title2: UIView, title2Val: UIView, titleSize: CGFloat, valSize: CGFloat) {
        title1.translatesAutoresizingMaskIntoConstraints = false
        title1.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 30).isActive = true
        title1.heightAnchor.constraint(equalToConstant: titleSize).isActive = true
        title1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        title1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        title1Val.translatesAutoresizingMaskIntoConstraints = false
        title1Val.topAnchor.constraint(equalTo: title1.bottomAnchor, constant: 5).isActive = true
        title1Val.heightAnchor.constraint(equalToConstant: valSize).isActive = true
        title1Val.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        title1Val.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        title2.translatesAutoresizingMaskIntoConstraints = false
        title2.topAnchor.constraint(equalTo: title1Val.bottomAnchor, constant: 10).isActive = true
        title2.heightAnchor.constraint(equalToConstant: titleSize).isActive = true
        title2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        title2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        title2Val.translatesAutoresizingMaskIntoConstraints = false
        title2Val.topAnchor.constraint(equalTo: title2.bottomAnchor, constant: 5).isActive = true
//        title2Val.heightAnchor.constraint(equalToConstant: valSize).isActive = true
        title2Val.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        title2Val.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
}
