//
//  ViewController.swift
//  BLE Demo
//
//  Created by Nimblechapps iOS on 22/07/17.
//  Copyright © 2017 Nimblechapps iOS. All rights reserved.
//

import UIKit
import CoreBluetooth
class ViewController: UIViewController {
@IBOutlet var tableView : UITableView!
@IBOutlet var lblStatus : UILabel!
var centralManager: CBCentralManager?
var peripherals = Array<CBPeripheral>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBluetooth()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupBluetooth(){
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Extenstion to manage the Core Bluetooth Methods
extension ViewController : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
            lblStatus.text = "Available Bluetooth Devices"
        }
        else {
            let alert = UIAlertController.init(title: "Bluetooth Not Switched On", message: "Switch on the bluetooth and try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                
            }));
            self.present(alert, animated: true, completion: { 
                
            })
            lblStatus.text = "Bluetooth not swictched on"
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripherals.contains(peripheral){
           tableView.reloadData()
        }
        else {
            peripherals.append(peripheral)
            tableView.reloadData()
        }
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        centralManager?.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        // If you know the UDID of specific service you can pass that here
        //peripheral.discoverServices([CBUUID(nsuuid: UUID(uuidString: "")!)])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let alert = UIAlertController(title: "Error", message: "There was error connecting to the device. Try again later", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// Extenstion to manage the Peripheral Services
extension ViewController : CBPeripheralDelegate
{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        //
        if (error == nil) {
            for service in peripheral.services! {
                
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
        else {
            let alert = UIAlertController(title: "Error", message: "There was error discovering Services", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        //
        if (error == nil) {
            print(service.characteristics ?? "")
        }
        else {
            let alert = UIAlertController(title: "Error", message: "There was error discovering characteristics", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


// Extenstion to manage the UITableView
extension ViewController : UITableViewDataSource , UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell        
        let peripheral = peripherals[indexPath.row]
        if  peripheral.name == "" || peripheral.name == nil {
           cell.textLabel?.text = String(describing: peripheral.identifier)
        }
        else {
          cell.textLabel?.text = peripheral.name
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        centralManager?.connect(peripherals[indexPath.row], options: nil)
    }
}
