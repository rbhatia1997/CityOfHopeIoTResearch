//
//  ReceiveData.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

//import UIKit
//import CoreBluetooth
//
//class ReceiveData: UIView {
//
//    var read = false
//    var colorTheme = UIColor()
//
//    var timestep = [Float]()
//    var q0 = [[Float]]()
//    var q1 = [[Float]]()
//    var q2 = [[Float]]()
//    var q3 = [[Float]]()
//
//    private var serviceUUID = CBUUID(string: "2f391f0f-1c30-46fb-a972-a22c2f7570ee")
//    private var char0UUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
//
//    let startButton = UIButton()
//    let submitButton = UIButton()
//
//    // for debugging purposes
//    let countLabel = UILabel()
//    let valueLabel = UILabel()
//
//    private var centralManager: CBCentralManager!
//    private var wearablePeripheral: CBPeripheral!
//
//    init() {
//        super.init(frame: .zero)
//        self.backgroundColor = .clear
//
////        centralManager = CBCentralManager(delegate: (self as CBCentralManagerDelegate), queue: nil, options: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func updateView(color: UIColor) {
//        colorTheme = color
//
//        centralManager = CBCentralManager(delegate: (self as CBCentralManagerDelegate), queue: nil, options: nil)
//
//        setupViews()
//        setupConstraints()
//    }
//}
//
//extension ReceiveData: CBCentralManagerDelegate {
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case .unknown:
//            print("central.state is .unknown")
//        case .resetting:
//            print("central.state is .resetting")
//        case .unsupported:
//            print("central.state is .unsupported")
//        case .unauthorized:
//            print("central.state is .unauthorized")
//        case .poweredOff:
//            print("central.state is .poweredOff")
//        case .poweredOn:
//            print("central.state is .poweredOn")
//            centralManager.scanForPeripherals(withServices: [serviceUUID])
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        print(peripheral)
//        wearablePeripheral = peripheral
//        wearablePeripheral.delegate = (self as CBPeripheralDelegate)
//        centralManager.stopScan()
//        centralManager.connect(wearablePeripheral)
//    }
//
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("Connected!")
//        print(peripheral.name ?? "not detected")
//        wearablePeripheral.discoverServices([serviceUUID])
//    }
//
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        print("Disconnected... scanning for peripherals")
//        centralManager.scanForPeripherals(withServices: [serviceUUID])
//    }
//}
//
//extension ReceiveData: CBPeripheralDelegate {
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else { return }
//        for service in services {
//            print(service)
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else { return }
//
//        for characteristic in characteristics {
//            print(characteristic)
//
//            if characteristic.properties.contains(.read) {
//                print("\(characteristic.uuid): properties contains .read")
//                peripheral.readValue(for: characteristic)
//            }
//            if characteristic.properties.contains(.notify) {
//                print("\(characteristic.uuid): properties contains .notify")
//                peripheral.setNotifyValue(true, for: characteristic)
//            }
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        switch characteristic.uuid {
//        case char0UUID:
//            let data = characteristic.value!
//            let farr: [Float] = dataToFloats(data: data, numFloats: 17)
//
//            if read {
//                timestep.append(farr[0])
//                q0.append([farr[1], farr[2], farr[3], farr[4]])
//                q1.append([farr[5], farr[6], farr[7], farr[8]])
//                q2.append([farr[9], farr[10], farr[11], farr[12]])
//                q3.append([farr[13], farr[14], farr[15], farr[16]])
//
//                countLabel.text = "number of entries: \(timestep.count)"
//
//                var str0 = ""
//                var str1 = ""
//                var str2 = ""
//                var str3 = ""
//
//                for i in 0..<4 {
//                    str0 += "\(String(format: "%.3f", q0.last?[i] ?? Float(i))) "
//                    str1 += "\(String(format: "%.3f", q1.last?[i] ?? Float(i))) "
//                    str2 += "\(String(format: "%.3f", q2.last?[i] ?? Float(i))) "
//                    str3 += "\(String(format: "%.3f", q3.last?[i] ?? Float(i))) "
//                }
//
//                valueLabel.text = "timestep: \(String(format: "%.0f", timestep.last ?? 120)) \nq0: \(str0) \nq1: \(str1) \nq2: \(str2) \nq3: \(str3)"
//
//            } else {
//                timestep.removeAll()
//                q0.removeAll()
//                q1.removeAll()
//                q2.removeAll()
//                q3.removeAll()
//
//                valueLabel.text = "here bois"
//                countLabel.text = "no data"
//            }
//        default:
//            break
//        }
//    }
//}
//
//extension ReceiveData {
//    @objc func startTapped(_ sender: UIButton) {
//        if read {
//            startButton.setTitle("  Start exercise  ", for: .normal)
//            startButton.setTitleColor(.white, for: .normal)
//            startButton.setButtonFrame(borderWidth: 1.0, borderColor: .clear, cornerRadius: 5, fillColor: UIColor(white: 0, alpha: 0.20))
//        } else {
//            startButton.setTitle("  Exercise running  ", for: .normal)
//            startButton.setTitleColor(.white, for: .normal)
//            startButton.setButtonFrame(borderWidth: 1.0, borderColor: .clear, cornerRadius: 5, fillColor: hsbShadeTint(color: colorTheme, sat: 0.50))
//        }
//
//        read = !read
//        self.addSubview(startButton)
//    }
//
//    @objc func submitTapped(_ sender: UIButton) {
//
//        print("session submitted")
//    }
//}
//
//extension ReceiveData: ViewConstraintProtocol {
//    func setupViews() {
//        startButton.setButtonParams(color: .white, string: "  Start exercise  ", ftype: defFont, fsize: 20, align: .center)
//        startButton.setButtonFrame(borderWidth: 1.0, borderColor: .clear, cornerRadius: 5, fillColor: UIColor(white: 0, alpha: 0.20))
//        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
//        self.addSubview(startButton)
//
//        submitButton.setButtonParams(color: .gray, string: "  Submit session  ", ftype: defFont, fsize: 20, align: .center)
//        submitButton.setButtonFrame(borderWidth: 1.0, borderColor: .gray, cornerRadius: 5, fillColor: .clear)
////        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
//        self.addSubview(submitButton)
//
//        countLabel.setLabelParams(color: .black, string: "--", ftype: defFont, fsize: 14, align: .left)
//        self.addSubview(countLabel)
//
//        valueLabel.setLabelParams(color: .black, string: "--", ftype: defFont, fsize: 14, align: .left)
//        self.addSubview(valueLabel)
//    }
//
//    func setupConstraints() {
//        startButton.translatesAutoresizingMaskIntoConstraints = false
//        startButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        startButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
////        startButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//
//        submitButton.translatesAutoresizingMaskIntoConstraints = false
//        submitButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
//        submitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        submitButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
////        submitButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//
//        countLabel.translatesAutoresizingMaskIntoConstraints = false
//        countLabel.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20).isActive = true
//        countLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
//        countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//
//        valueLabel.translatesAutoresizingMaskIntoConstraints = false
//        valueLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 20).isActive = true
//        valueLabel.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -20).isActive = true
////        valueLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//    }
//}
