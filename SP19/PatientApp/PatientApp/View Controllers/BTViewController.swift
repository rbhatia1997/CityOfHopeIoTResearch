//
//  BTViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreBluetooth

class BTViewController: UIViewController {
    
    var serviceUUID = CBUUID(string: "6969")
    
    let headerView = Header()
    let serviceTitle = UILabel()
    var serviceUUIDLabel = UILabel()
    let peripheralTitle = UILabel()
    var peripheralName = UILabel()
    let charTitle = UILabel()
    var charUUID = UILabel()
    let charValTitle = UILabel()
    var charVal = UILabel()
    
    var centralManager: CBCentralManager!
    var wearablePeripheral: CBPeripheral!
    
    let homeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: (self as CBCentralManagerDelegate), queue: nil, options: nil)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        headerView.updateHeader(text: "Blutoof", color: .lightGray, fsize: 30)
        
        serviceTitle.setLabelParams(color: .black, string: "Service UUID: ", ftype: "Montserrat-Regular", fsize: 20, align: .left)
        serviceUUIDLabel.setLabelParams(color: .black, string: "--", ftype: "Montserrat-Regular", fsize: 14, align: .left)
        
        peripheralTitle.setLabelParams(color: .black, string: "Peripheral Name: ", ftype: "Montserrat-Regular", fsize: 20, align: .left)
        peripheralName.setLabelParams(color: .black, string: "--", ftype: "Montserrat-Regular", fsize: 14, align: .left)
        
        charTitle.setLabelParams(color: .black, string: "Characteristic UUID: ", ftype: "Montserrat-Regular", fsize: 20, align: .left)
        charUUID.setLabelParams(color: .black, string: "--", ftype: "Montserrat-Regular", fsize: 14, align: .left)
        
        charValTitle.setLabelParams(color: .black, string: "Characteristic Data: ", ftype: "Montserrat-Regular", fsize: 20, align: .left)
        charVal.setLabelParams(color: .black, string: "--", ftype: "Montserrat-Regular", fsize: 14, align: .left)
        
        self.view.addSubview(headerView)
        self.view.addSubview(serviceTitle)
        self.view.addSubview(serviceUUIDLabel)
        self.view.addSubview(peripheralTitle)
        self.view.addSubview(peripheralName)
        self.view.addSubview(charTitle)
        self.view.addSubview(charUUID)
        self.view.addSubview(charValTitle)
        self.view.addSubview(charVal)
        
        homeButton.setButtonParams(color: .gray, string: "Home", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(homeButton)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        serviceTitle.translatesAutoresizingMaskIntoConstraints = false
        serviceTitle.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        serviceTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        serviceTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        serviceTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        serviceUUIDLabel.translatesAutoresizingMaskIntoConstraints = false
        serviceUUIDLabel.topAnchor.constraint(equalTo: serviceTitle.bottomAnchor, constant: 20).isActive = true
        serviceUUIDLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        serviceUUIDLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        serviceUUIDLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        peripheralTitle.translatesAutoresizingMaskIntoConstraints = false
        peripheralTitle.topAnchor.constraint(equalTo: serviceUUIDLabel.bottomAnchor, constant: 20).isActive = true
        peripheralTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        peripheralTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        peripheralTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        peripheralName.translatesAutoresizingMaskIntoConstraints = false
        peripheralName.topAnchor.constraint(equalTo: peripheralTitle.bottomAnchor, constant: 20).isActive = true
        peripheralName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        peripheralName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        peripheralName.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        charTitle.translatesAutoresizingMaskIntoConstraints = false
        charTitle.topAnchor.constraint(equalTo: peripheralName.bottomAnchor, constant: 20).isActive = true
        charTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        charTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        charTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        charUUID.translatesAutoresizingMaskIntoConstraints = false
        charUUID.topAnchor.constraint(equalTo: charTitle.bottomAnchor, constant: 20).isActive = true
        charUUID.heightAnchor.constraint(equalToConstant: 20).isActive = true
        charUUID.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        charUUID.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        charValTitle.translatesAutoresizingMaskIntoConstraints = false
        charValTitle.topAnchor.constraint(equalTo: charUUID.bottomAnchor, constant: 20).isActive = true
        charValTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        charValTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        charValTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        charVal.translatesAutoresizingMaskIntoConstraints = false
        charVal.topAnchor.constraint(equalTo: charValTitle.bottomAnchor, constant: 20).isActive = true
        charVal.heightAnchor.constraint(equalToConstant: 20).isActive = true
        charVal.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        charVal.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        homeButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        homeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        homeButton.widthAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
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
//        switch characteristic.uuid {
//        case Master.BTVars.IMU0_UUID:
//
//            let charString = characteristic.value
//            charVal.text = String(data: charString!, encoding: .utf32)
//            charTitle.text = characteristic.uuid.uuidString
////        case heartRateMeasurementCharacteristicCBUUID:
////            let bpm = 69 // heartRate(from: characteristic)
////            onHeartRateReceived(bpm)
////            let data = characteristic.value
////            serviceUUIDLabel.text = "."
////            characteristicUUID.text = characteristic.uuid.uuidString
////            bodySensorLocationLabel.text = String(data: data!, encoding: .utf8)
//        default:
//            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//        }
        serviceUUIDLabel.text = serviceUUID.uuidString
        peripheralName.text = peripheral.name
        charUUID.text = characteristic.uuid.uuidString
        let charString = characteristic.value
        charVal.text = String(data: charString!, encoding: .utf32)
    }
    
//    private func bodyLocation(from characteristic: CBCharacteristic) -> String {
//        guard let characteristicData = characteristic.value,
//            let byte = characteristicData.first else { return "Error" }
//        
//        switch byte {
//        case 0: return "Other"
//        case 1: return "Chest"
//        case 2: return "Wrist"
//        case 3: return "Finger"
//        case 4: return "Hand"
//        case 5: return "Ear Lobe"
//        case 6: return "Foot"
//        default:
//            return "Reserved for future use"
//        }
//    }
    
    //  private func heartRate(from characteristic: CBCharacteristic) -> Int {
    //    guard let characteristicData = characteristic.value else { return -1 }
    //    let byteArray = [UInt8](characteristicData)
    //
    //    // See: https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.heart_rate_measurement.xml
    //    // The heart rate mesurement is in the 2nd, or in the 2nd and 3rd bytes, i.e. one one or in two bytes
    //    // The first byte of the first bit specifies the length of the heart rate data, 0 == 1 byte, 1 == 2 bytes
    //    let firstBitValue = byteArray[0] & 0x01
    //    if firstBitValue == 0 {
    //      // Heart Rate Value Format is in the 2nd byte
    //      return Int(byteArray[1])
    //    } else {
    //      // Heart Rate Value Format is in the 2nd and 3rd bytes
    //      return (Int(byteArray[1]) << 8) + Int(byteArray[2])
    //    }
    //  }
    
    @objc func homeButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHomeVCFromBTVC", sender: sender)
    }
}
