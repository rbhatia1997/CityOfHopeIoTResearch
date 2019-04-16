//
//  ExerciseSettingsViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 4/10/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

var devMode = false

class SettingsViewController: UIViewController {

    let headerView = Header()
    private let backButton = UIButton()
    
    private let devButton = UIButton()
    
    private let userTitle = UILabel()
    private let updateButton = UIButton()
    private var userLabels = [UILabel]()
    private var userFields = [UITextField]()
    private var datePicker = UIDatePicker()
    
    private var exerciseLabel = UILabel()
    private let exerciseTableView = UITableView()
    
    private let cellIdentifier = "pickerCell"
    
    private let userCategories = ["name", "age", "sex", "start date"]
    private var userValues = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray.hsbBrt(0.9)
        
        getUserData()
        userValues = userData
        
        reloadAllExerciseData()

        setupViews()
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
        
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
    }
}

// MARK: button actions
extension SettingsViewController {
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHomeVCfromSettingsVC", sender: sender)
    }
    
    @objc func devButtonTapped(_ sender: UIButton) {
        devMode = !devMode
        devButton.setButtonParams(color: devMode ? .gray : .white, string: "Developer Mode is \(devMode ? "On": "Off")", ftype: defFont, fsize: 20, align: .center)
        devButton.setButtonFrame(borderWidth: 1.0, borderColor: devMode ? .white : .gray, cornerRadius: devButton.frame.height/2, fillColor: devMode ? .white : .gray)
        self.view.addSubview(backButton)
    }
    
    @objc func updateButtonTapped(_ sender: UIButton) {
        user.name = userFields[0].text ?? "there"
        user.age = Int16( userFields[1].text ?? "0" ) ?? 0
        user.sex = userFields[2].text ?? "Anything"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        user.startDate = dateFormatter.date(from: userFields[3].text ?? "Jun 09, 1900")!
        
        do {
            try context.save()
            print("User data updated")
        } catch {
            print("Failed saving")
        }
        
        self.view.endEditing(true)
        
        let dismissAlert = UIAlertController(title: "Notice", message: "User data has been updated", preferredStyle: .alert)
        dismissAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(dismissAlert, animated: true, completion: nil)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        userFields[3].text = dateFormatter.string(from: sender.date)
    }
}

extension SettingsViewController: ViewConstraintProtocol {
    func setupViews() {
        headerView.updateHeader(text: "Settings", color: .white, fsize: 30)
        self.view.addSubview(headerView)
        
        backButton.setButtonParams(color: .gray, string: "Back", ftype: defFont, fsize: 16, align: .center)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        devButton.setButtonParams(color: devMode ? .gray : .white, string: "Developer Mode is \(devMode ? "On": "Off")", ftype: defFont, fsize: 20, align: .center)
        devButton.setButtonFrame(borderWidth: 1.0, borderColor: devMode ? .white : .gray, cornerRadius: devButton.frame.height/2, fillColor: devMode ? .white : .gray)
        devButton.addTarget(self, action: #selector(devButtonTapped), for: .touchUpInside)
        self.view.addSubview(devButton)
        
        userTitle.setLabelParams(color: .gray, string: "User Info", ftype: defFont, fsize: 20, align: .left)
        self.view.addSubview(userTitle)
        
        updateButton.setButtonParams(color: .gray, string: "Update", ftype: defFont, fsize: 14, align: .center)
        updateButton.setButtonFrame(borderWidth: 1.0, borderColor: .white, cornerRadius: updateButton.frame.height/2, fillColor: .white, inset: 5)
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        self.view.addSubview(updateButton)
        
        for i in 0..<userCategories.count {
            let label = UILabel()
            label.setLabelParams(color: .gray, string: "\(userCategories[i]): ", ftype: defFont, fsize: 14, align: .left)
            userLabels.append(label)
            self.view.addSubview(userLabels[i])
        }
        
        for i in 0..<userValues.count {
            let field = UITextField()
            field.frame = .zero
            field.backgroundColor = .white
            field.text = userValues[i]
            field.font = UIFont(name: defFont, size: 14)!
            field.textColor = .gray
            userFields.append(field)
            self.view.addSubview(userFields[i])
            
            userFields[i].delegate = self
        }
        
        userFields[3].inputView = datePicker
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        datePicker.date = dateFormatter.date(from: userFields[3].text ?? "Jun 09, 1900")!
        
        exerciseLabel.setLabelParams(color: .gray, string: "Exercise Selection", ftype: defFont, fsize: 20, align: .left)
        self.view.addSubview(exerciseLabel)
        
        exerciseTableView.frame = .zero
        exerciseTableView.backgroundColor = .clear
        exerciseTableView.rowHeight = 120
        exerciseTableView.register(PickerTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
//        exerciseTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.addSubview(exerciseTableView)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        
        devButton.translatesAutoresizingMaskIntoConstraints = false
        devButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        devButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        devButton.heightAnchor.constraint(equalToConstant: devButton.frame.height).isActive = true
        devButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        userTitle.translatesAutoresizingMaskIntoConstraints = false
        userTitle.topAnchor.constraint(equalTo: devButton.bottomAnchor, constant: 30).isActive = true
        userTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        userTitle.trailingAnchor.constraint(equalTo: updateButton.leadingAnchor, constant: -20).isActive = true
        
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.centerYAnchor.constraint(equalTo: userTitle.centerYAnchor).isActive = true
        updateButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        updateButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        for i in 0..<userLabels.count {
            if i == 0 {
                userLabels[i].topAnchor.constraint(equalTo: userTitle.bottomAnchor, constant: 20).isActive = true
            } else {
                userLabels[i].topAnchor.constraint(equalTo: userLabels[i-1].bottomAnchor, constant: 10).isActive = true
            }
            
            userLabels[i].translatesAutoresizingMaskIntoConstraints = false
            userLabels[i].leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            userLabels[i].widthAnchor.constraint(equalToConstant: 80).isActive = true
        }
        
        for i in 0..<userFields.count {
            userFields[i].translatesAutoresizingMaskIntoConstraints = false
            userFields[i].centerYAnchor.constraint(equalTo: userLabels[i].centerYAnchor).isActive = true
            userFields[i].leadingAnchor.constraint(equalTo: userLabels[i].trailingAnchor, constant: 20).isActive = true
            userFields[i].trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        }
        
        exerciseLabel.translatesAutoresizingMaskIntoConstraints = false
        exerciseLabel.topAnchor.constraint(equalTo: userFields.last!.bottomAnchor, constant: 30).isActive = true
        exerciseLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        exerciseLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        exerciseTableView.translatesAutoresizingMaskIntoConstraints = false
        exerciseTableView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 20).isActive = true
        exerciseTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        exerciseTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        exerciseTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! PickerTableViewCell
        
        let colorView = UIView()
        colorView.frame = .zero
        colorView.backgroundColor = .white
        cell.selectedBackgroundView = colorView
        cell.pickerCellDelegate = self
        cell.useButton.tag = indexPath.row
        cell.romPicker.tag = indexPath.row
        cell.repPicker.tag = indexPath.row
        cell.updatePickerCell(name: exercises[indexPath.row].name, icon: UIImage(named: exercises[indexPath.row].icon)!, use: exercises[indexPath.row].use, rom: exercises[indexPath.row].baselineRom, rep: exercises[indexPath.row].baselineRep)

        return cell
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SettingsViewController: PickerTableViewCellDelegate {
    func useButtonPressed(_ tag: Int) {
        print("pressed use button")
        exercises[tag].use = !exercises[tag].use
        
        do {
            try context.save()
            print("Exercise data updated")
        } catch {
            print("Failed saving")
        }
        
        exerciseTableView.reloadData()
    }
    
    func setRom(_ tag: Int, _ rom: Float) {
        print("set rom")
        reloadAllExerciseData()
        exercises[tag].baselineRom = rom
        
        do {
            try context.save()
            print("Exercise data updated")
        } catch {
            print("Failed saving")
        }
        
        exerciseTableView.reloadData()
    }
    
    func setRep(_ tag: Int, _ rep: Int16) {
        print("set rep")
        reloadAllExerciseData()
        exercises[tag].baselineRep = rep
        
        do {
            try context.save()
            print("Exercise data updated")
        } catch {
            print("Failed saving")
        }
        
        exerciseTableView.reloadData()
    }
}
