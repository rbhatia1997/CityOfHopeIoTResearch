//
//  HomeViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController {

    // load these variables with core data
    var goalString = [String]()
    var exerciseValues = [CGFloat]()
    var exerciseNames = [String]()
    
    // private variables
    private let colorTheme = UIColor(named: "blue")!
    private let settingsButton = UIButton()

    // subviews
    private let headerView = Header()
    private let goalView = HomeMotivator()
    private let circleGraph = SimpleProgressGraph()
    private let BTView = BTConn()
    
    // bluetooth variables
    private var serviceUUID = CBUUID(string: "2f391f0f-1c30-46fb-a972-a22c2f7570ee")
    private var char0UUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
    
    private var centralManager: CBCentralManager!
    private var wearablePeripheral: CBPeripheral!
    
    private var onVC = true
    
    // construction variables
    let BTButton = UIButton()
    let CDButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: (self as CBCentralManagerDelegate), queue: nil, options: nil)
        
        // set the tab bar item title and image
        self.tabBarItem.selectedImage = UIImage(named: "home")!
        self.tabBarItem.title = "Home"
        
        // displayUI
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadUser()
        headerView.updateHeader(text: "Hello, \(user.name)", color: colorTheme, fsize: 30)
        
        onVC = true
        centralManager.scanForPeripherals(withServices: [serviceUUID])
        
        reloadLocalVariables()
        goalView.updateGoals(goalList: goalString)
        circleGraph.updateProgressGraph(color: colorTheme, exNum: exerciseValues.count, exVal: exerciseValues, exName: exerciseNames)
        
        if devMode {
            devButtonSetup()
        } else {
            if BTButton.tag == 104 && CDButton.tag == 104{
                BTButton.removeFromSuperview()
                CDButton.removeFromSuperview()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        onVC = false
        if let peripheral = wearablePeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
}

extension HomeViewController: LoadLocalProtocol {
    func reloadLocalVariables() {
        goalString.removeAll()
        reloadGoalData()
        for goal in goals {
            goalString.append(goal.text)
        }
        
        exerciseNames.removeAll()
        reloadExerciseData()
        for exercise in exercises {
            exerciseNames.append(exercise.name)
            
        }
        
        exerciseValues.removeAll()
        reloadExerciseMetaData()
        var maxArray = [CGFloat]()

        for i in 0..<exerciseMetas.count - 1 {
            maxArray.removeAll()
            for meta in exerciseMetas[i] {
                maxArray.append(CGFloat(meta.max))
            }
            let baselineMax = i >= baseline.count ? CGFloat(baseline[0][1]) : CGFloat(baseline[i][1])
            let maxForExercise = (maxArray.max() ?? 0)
            exerciseValues.append(exerciseMetas[i].count == 0 ? 0 : maxForExercise / baselineMax)
        }
        if exerciseValues.count == 0 {
            exerciseValues.append(0)
        }
    }
}

extension HomeViewController: CBCentralManagerDelegate {
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
        BTView.updateBTStatus(connStat: true, deviceString: peripheral.name ?? "Unknown device")
        print("Connected!")
        print(peripheral.name ?? "not detected")
        wearablePeripheral.discoverServices([serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        BTView.updateBTStatus(connStat: false, deviceString: "N/A")
        print("\(peripheral.name ?? "Unknown device") disconnected")
        if onVC {
            print("Scanning for peripherals...")
            centralManager.scanForPeripherals(withServices: [serviceUUID])
        }
    }
}

extension HomeViewController: CBPeripheralDelegate {
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
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {}
}

// MARK: button actions
extension HomeViewController {
    // sends the user to the BT testing page
    @objc func BTButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toBluetoothVC", sender: sender)
    }
    
    @objc func CDButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toCoreDataVC", sender: sender)
    }
    
    // brings the user back to the home VC
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {}
}

extension HomeViewController: ViewConstraintProtocol {
    internal func setupViews() {
        // update all of the views
        reloadUser()
        headerView.updateHeader(text: "Hello, \(user.name)", color: colorTheme, fsize: 30)
        BTView.updateBTStatus(connStat: false, deviceString: "N/A")
        
        // add the subviews to the main view
        self.view.addSubview(headerView)
        self.view.addSubview(goalView)
        self.view.addSubview(circleGraph)
        self.view.addSubview(BTView)
        
        settingsButton.setButtonParams(color: .gray, string: "Settings", ftype: defFont, fsize: 16, align: .center)
        settingsButton.addTarget(self, action: #selector(SettingsButtonPressed), for: .touchUpInside)
        self.view.addSubview(settingsButton)
}
    
    internal func setupConstraints() {
        // set the header view constraints
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 140.0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // set the goal list view constraints
        goalView.translatesAutoresizingMaskIntoConstraints = false
        goalView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        goalView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 4/20).isActive = true
        goalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        goalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // set the circular graph view constraints
        circleGraph.translatesAutoresizingMaskIntoConstraints = false
        circleGraph.topAnchor.constraint(equalTo: goalView.bottomAnchor, constant: 20).isActive = true
        circleGraph.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 8/20).isActive = true
        circleGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        circleGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // set the BT connection status view constraints
        BTView.translatesAutoresizingMaskIntoConstraints = false
        BTView.topAnchor.constraint(equalTo: circleGraph.bottomAnchor, constant: -10).isActive = true
        BTView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/20).isActive = true
        BTView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        BTView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func devButtonSetup() {
        BTButton.setButtonParams(color: .gray, string: "BT", ftype: defFont, fsize: 16, align: .center)
        BTButton.addTarget(self, action: #selector(BTButtonPressed), for: .touchUpInside)
        BTButton.tag = 104
        self.view.addSubview(BTButton)
        
        CDButton.setButtonParams(color: .gray, string: "CD", ftype: defFont, fsize: 16, align: .center)
        CDButton.addTarget(self, action: #selector(CDButtonPressed), for: .touchUpInside)
        CDButton.tag = 104
        self.view.addSubview(CDButton)
        
        BTButton.translatesAutoresizingMaskIntoConstraints = false
        BTButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        BTButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        BTButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        BTButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        
        CDButton.translatesAutoresizingMaskIntoConstraints = false
        CDButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        CDButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        CDButton.bottomAnchor.constraint(equalTo: BTButton.topAnchor).isActive = true
        CDButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
    }
    
    @objc func SettingsButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toSettingsVC", sender: sender)
    }
}
