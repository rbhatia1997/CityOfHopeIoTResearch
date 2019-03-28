//
//  GoalsViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController, ViewConstraintProtocol {

    let colorTheme = UIColor(named: "yellow")!
    
    // global variables
    private let cellIdentifier: String = "goalCellIdentifier"
    
    // Subviews
    let headerView = Header()
    let goalsTable = UITableView()
    
    private let addButton = UIButton()
    private let removeButton = UIButton()
    
    private var selectedRowIndex: Int = largeNumber
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.selectedImage = UIImage(named: "goals")!
        self.tabBarItem.title = "Goals"
        
        goalsTable.delegate = self
        goalsTable.dataSource = self
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData(entityName: "Goal")
        goalsTable.reloadData()
        
        goalsTable.estimatedRowHeight = 80
        goalsTable.rowHeight = UITableView.automaticDimension
    }
    
    internal func setupViews() {
        headerView.updateHeader(text: "Goals", color: hsbShadeTint(color: colorTheme, sat: 0.25), fsize: 30)
        self.view.addSubview(headerView)
        
        addButton.setButtonParams(color: .gray, string: "Add", ftype: "Montserrat-Regular", fsize: 20, align: .center)
        addButton.addTarget(self, action: #selector(addGoalsCell), for: .touchUpInside)
        self.view.addSubview(addButton)
        
        removeButton.setButtonParams(color: .gray, string: "Delete", ftype: "Montserrat-Regular", fsize: 20, align: .center)
        removeButton.addTarget(self, action: #selector(removeGoalsCell), for: .touchUpInside)
        self.view.addSubview(removeButton)
        
        goalsTable.frame = .zero
        goalsTable.backgroundColor = .clear
        goalsTable.register(GoalsTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        goalsTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.addSubview(goalsTable)
    }
    
    internal func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        goalsTable.translatesAutoresizingMaskIntoConstraints = false
        goalsTable.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        goalsTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        goalsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        goalsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.topAnchor.constraint(equalTo: goalsTable.bottomAnchor, constant: 10).isActive = true
        addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -100).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.topAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        removeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 100).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.layoutIfNeeded()
        showBorder(view: addButton, corner: 5, color: .gray)
        showBorder(view: removeButton, corner: 5, color: .gray)
    }
    
    @objc func addGoalsCell(_ sender: UIButton) {
        print("add goals cell")
        
        var goalText: String!
        
        let alert = UIAlertController(title: "Add Goal", message: "Enter your goal here", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            goalText = textField.text
            addGoal(achieved: false, entry: goalText)
            getData(entityName: "Goal")
            self.goalsTable.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func removeGoalsCell(_ sender: UIButton) {
        print("remove goals cells")
        clearIndexedEntityData(selectedRowIndex, entityName: "Goal")
        getData(entityName: "Goal")
        self.goalsTable.reloadData()
        selectedRowIndex = largeNumber
    }
}

extension GoalsViewController: GoalsTableViewCellDelegate {
    func doneButtonPressed(_ tag: Int) {
        print("pressed done button")
        goalList[tag].achieved = !goalList[tag].achieved
        getData(entityName: "Goal")
        goalsTable.reloadData()
    }
}

extension GoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! GoalsTableViewCell
        
        let index = indexPath.row + 1
        let entry = goalList[indexPath.row].entry
        let achieved = goalList[indexPath.row].achieved
        
        let colorView = UIView()
        colorView.frame = .zero
        colorView.backgroundColor = colorTheme
        cell.selectedBackgroundView = colorView
        
        cell.goalCellDelegate = self
        cell.doneButton.tag = indexPath.row
        cell.updateGoalCell(number: index, goal: entry, isDone: achieved)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == goalsTable {
            if selectedRowIndex != indexPath.row {
                selectedRowIndex = indexPath.row
            } else {
                selectedRowIndex = largeNumber
                goalsTable.deselectRow(at: indexPath, animated: false)
            }
        }
    }
}
