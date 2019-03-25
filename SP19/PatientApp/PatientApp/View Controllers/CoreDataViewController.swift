//
//  CoreDataViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/23/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

class CoreDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // global variables
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var exerciseList = [Exercise]()
    private var goalList = [Goal]()
    private var wellnessQsList = [Wellness]()
    
    private var selectedGoalIndex: Int?
    
    // subviews
    let headerView = Header()
    
    // construction variables
    let homeButton = UIButton()
    
    // reset buttons
    let exerciseHeader = UILabel()
    let exerciseReset = UIButton()
    let exerciseAdd = UIButton()
    let exerciseRemove = UIButton()
    let exerciseTable = UITableView()
    let exerciseCellIdentifier = "exerciseCell"
    
    let goalsHeader = UILabel()
    let goalsReset = UIButton()
    let goalsAdd = UIButton()
    let goalsRemove = UIButton()
    let goalsTable = UITableView()
    let goalCellIdentifier = "goalCell"
    
    let wellnessHeader = UILabel()
    let wellnessReset = UIButton()
    let wellnessAdd = UIButton()
    let wellnessRemove = UIButton()
    let wellnessTable = UITableView()
    let wellnessCellIdentifier = "wellnessCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseTable.delegate = self
        exerciseTable.dataSource = self
        goalsTable.delegate = self
        goalsTable.dataSource = self
        wellnessTable.delegate = self
        wellnessTable.dataSource = self
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
    }
    
    private func setupViews() {
        headerView.updateHeader(text: "Core Data", color: .lightGray, fsize: 30)
        self.view.addSubview(headerView)
        
        // exercise
        exerciseHeader.setLabelParams(color: .black, string: "Exercises", ftype: "Montserrat-Regular", fsize: 16, align: .left)
        exerciseReset.setButtonParams(color: .lightGray, string: "Reset", ftype: "Montserrat-Regular", fsize: 16, align: .right)
        exerciseReset.addTarget(self, action: #selector(resetExerciseCells), for: .touchUpInside)
        exerciseAdd.setButtonParams(color: .lightGray, string: "+", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        exerciseAdd.addTarget(self, action: #selector(addExerciseCell), for: .touchUpInside)
        exerciseRemove.setButtonParams(color: .lightGray, string: "-", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        exerciseRemove.addTarget(self, action: #selector(removeExerciseCell), for: .touchUpInside)
        exerciseTable.frame = .zero
        exerciseTable.backgroundColor = .clear
        exerciseTable.rowHeight = 44
        exerciseTable.register(CDExerciseTableViewCell.self, forCellReuseIdentifier: self.exerciseCellIdentifier)
        self.view.addSubview(exerciseHeader)
        self.view.addSubview(exerciseReset)
        self.view.addSubview(exerciseAdd)
        self.view.addSubview(exerciseRemove)
        self.view.addSubview(exerciseTable)
        
        // goals
        goalsHeader.setLabelParams(color: .black, string: "Goals", ftype: "Montserrat-Regular", fsize: 16, align: .left)
        goalsReset.setButtonParams(color: .lightGray, string: "Reset", ftype: "Montserrat-Regular", fsize: 16, align: .right)
        goalsReset.addTarget(self, action: #selector(resetGoalsCells), for: .touchUpInside)
        goalsAdd.setButtonParams(color: .lightGray, string: "+", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        goalsAdd.addTarget(self, action: #selector(addGoalsCell), for: .touchUpInside)
        goalsRemove.setButtonParams(color: .lightGray, string: "-", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        goalsRemove.addTarget(self, action: #selector(removeGoalsCell), for: .touchUpInside)
        goalsTable.frame = .zero
        goalsTable.backgroundColor = .clear
        goalsTable.rowHeight = 44
        goalsTable.register(CDGoalTableViewCell.self, forCellReuseIdentifier: self.goalCellIdentifier)
        self.view.addSubview(goalsHeader)
        self.view.addSubview(goalsReset)
        self.view.addSubview(goalsAdd)
        self.view.addSubview(goalsRemove)
        self.view.addSubview(goalsTable)
        
        // wellness
        wellnessHeader.setLabelParams(color: .black, string: "Wellness", ftype: "Montserrat-Regular", fsize: 16, align: .left)
        wellnessReset.setButtonParams(color: .lightGray, string: "Reset", ftype: "Montserrat-Regular", fsize: 16, align: .right)
        wellnessReset.addTarget(self, action: #selector(resetWellnessCells), for: .touchUpInside)
        wellnessAdd.setButtonParams(color: .lightGray, string: "+", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        wellnessAdd.addTarget(self, action: #selector(addWellnessCell), for: .touchUpInside)
        wellnessRemove.setButtonParams(color: .lightGray, string: "-", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        wellnessRemove.addTarget(self, action: #selector(removeWellnessCell), for: .touchUpInside)
        wellnessTable.frame = .zero
        wellnessTable.backgroundColor = .clear
        wellnessTable.rowHeight = 44
        wellnessTable.register(CDWellnessTableViewCell.self, forCellReuseIdentifier: self.wellnessCellIdentifier)
        self.view.addSubview(wellnessHeader)
        self.view.addSubview(wellnessReset)
        self.view.addSubview(wellnessAdd)
        self.view.addSubview(wellnessRemove)
        self.view.addSubview(wellnessTable)
        
        homeButton.setButtonParams(color: .gray, string: "Home", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        self.view.addSubview(homeButton)
    }
    
    private func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // exercise
        exerciseAdd.translatesAutoresizingMaskIntoConstraints = false
        exerciseAdd.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        exerciseAdd.heightAnchor.constraint(equalToConstant: 20).isActive = true
        exerciseAdd.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -40).isActive = true
        exerciseAdd.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        exerciseRemove.translatesAutoresizingMaskIntoConstraints = false
        exerciseRemove.topAnchor.constraint(equalTo: exerciseAdd.topAnchor).isActive = true
        exerciseRemove.heightAnchor.constraint(equalToConstant: 20).isActive = true
        exerciseRemove.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 40).isActive = true
        exerciseRemove.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        exerciseHeader.translatesAutoresizingMaskIntoConstraints = false
        exerciseHeader.topAnchor.constraint(equalTo: exerciseAdd.topAnchor).isActive = true
        exerciseHeader.bottomAnchor.constraint(equalTo: exerciseAdd.bottomAnchor).isActive = true
        exerciseHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        exerciseHeader.trailingAnchor.constraint(equalTo: exerciseAdd.leadingAnchor).isActive = true
        
        exerciseReset.translatesAutoresizingMaskIntoConstraints = false
        exerciseReset.topAnchor.constraint(equalTo: exerciseAdd.topAnchor).isActive = true
        exerciseReset.bottomAnchor.constraint(equalTo: exerciseAdd.bottomAnchor).isActive = true
//        exerciseReset.leadingAnchor.constraint(equalTo: exerciseAdd.trailingAnchor).isActive = true
        exerciseReset.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        exerciseReset.widthAnchor.constraint(equalToConstant: exerciseReset.frame.width).isActive = true
        
        exerciseTable.translatesAutoresizingMaskIntoConstraints = false
        exerciseTable.topAnchor.constraint(equalTo: exerciseAdd.bottomAnchor, constant: 10).isActive = true
        exerciseTable.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        exerciseTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        exerciseTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // goals
        goalsAdd.translatesAutoresizingMaskIntoConstraints = false
        goalsAdd.topAnchor.constraint(equalTo: exerciseTable.bottomAnchor, constant: 20).isActive = true
        goalsAdd.heightAnchor.constraint(equalToConstant: 20).isActive = true
        goalsAdd.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -40).isActive = true
        goalsAdd.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        goalsRemove.translatesAutoresizingMaskIntoConstraints = false
        goalsRemove.topAnchor.constraint(equalTo: goalsAdd.topAnchor).isActive = true
        goalsRemove.heightAnchor.constraint(equalToConstant: 20).isActive = true
        goalsRemove.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 40).isActive = true
        goalsRemove.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        goalsHeader.translatesAutoresizingMaskIntoConstraints = false
        goalsHeader.topAnchor.constraint(equalTo: goalsAdd.topAnchor).isActive = true
        goalsHeader.bottomAnchor.constraint(equalTo: goalsAdd.bottomAnchor).isActive = true
        goalsHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        goalsHeader.trailingAnchor.constraint(equalTo: goalsAdd.leadingAnchor).isActive = true
        
        goalsReset.translatesAutoresizingMaskIntoConstraints = false
        goalsReset.topAnchor.constraint(equalTo: goalsAdd.topAnchor).isActive = true
        goalsReset.bottomAnchor.constraint(equalTo: goalsAdd.bottomAnchor).isActive = true
//        goalsReset.leadingAnchor.constraint(equalTo: goalsAdd.trailingAnchor).isActive = true
        goalsReset.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        goalsReset.widthAnchor.constraint(equalToConstant: goalsReset.frame.width).isActive = true
        
        goalsTable.translatesAutoresizingMaskIntoConstraints = false
        goalsTable.topAnchor.constraint(equalTo: goalsAdd.bottomAnchor, constant: 10).isActive = true
        goalsTable.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        goalsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        goalsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // wellness
        wellnessAdd.translatesAutoresizingMaskIntoConstraints = false
        wellnessAdd.topAnchor.constraint(equalTo: goalsTable.bottomAnchor, constant: 20).isActive = true
        wellnessAdd.heightAnchor.constraint(equalToConstant: 20).isActive = true
        wellnessAdd.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -40).isActive = true
        wellnessAdd.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        wellnessRemove.translatesAutoresizingMaskIntoConstraints = false
        wellnessRemove.topAnchor.constraint(equalTo: wellnessAdd.topAnchor).isActive = true
        wellnessRemove.heightAnchor.constraint(equalToConstant: 20).isActive = true
        wellnessRemove.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 40).isActive = true
        wellnessRemove.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        wellnessHeader.translatesAutoresizingMaskIntoConstraints = false
        wellnessHeader.topAnchor.constraint(equalTo: wellnessAdd.topAnchor).isActive = true
        wellnessHeader.bottomAnchor.constraint(equalTo: wellnessAdd.bottomAnchor).isActive = true
        wellnessHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        wellnessHeader.trailingAnchor.constraint(equalTo: wellnessAdd.leadingAnchor).isActive = true
        
        wellnessReset.translatesAutoresizingMaskIntoConstraints = false
        wellnessReset.topAnchor.constraint(equalTo: wellnessAdd.topAnchor).isActive = true
        wellnessReset.bottomAnchor.constraint(equalTo: wellnessAdd.bottomAnchor).isActive = true
//        wellnessReset.leadingAnchor.constraint(equalTo: wellnessAdd.trailingAnchor).isActive = true
        wellnessReset.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        wellnessReset.widthAnchor.constraint(equalToConstant: wellnessReset.frame.width).isActive = true
        
        wellnessTable.translatesAutoresizingMaskIntoConstraints = false
        wellnessTable.topAnchor.constraint(equalTo: wellnessAdd.bottomAnchor, constant: 10).isActive = true
        wellnessTable.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        wellnessTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        wellnessTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // home button
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        homeButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        homeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        homeButton.widthAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        
        self.view.layoutIfNeeded()
        showBorder(view: exerciseReset, corner: 5, color: .lightGray)
        showBorder(view: exerciseAdd, corner: 5, color: .lightGray)
        showBorder(view: exerciseRemove, corner: 5, color: .lightGray)
        showBorder(view: goalsReset, corner: 5, color: .lightGray)
        showBorder(view: goalsAdd, corner: 5, color: .lightGray)
        showBorder(view: goalsRemove, corner: 5, color: .lightGray)
        showBorder(view: wellnessReset, corner: 5, color: .lightGray)
        showBorder(view: wellnessAdd, corner: 5, color: .lightGray)
        showBorder(view: wellnessRemove, corner: 5, color: .lightGray)
        
//        showBorder(view: exerciseTable, corner: 5, color: .lightGray)
//        showBorder(view: goalsTable, corner: 5, color: .lightGray)
//        showBorder(view: wellnessTable, corner: 5, color: .lightGray)
    }

    @objc func homeButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHomeVCFromCDVC", sender: sender)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == exerciseTable {
            return exerciseList.count
        } else if tableView == goalsTable {
            return goalList.count
        } else if tableView == wellnessTable {
            return wellnessQsList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == exerciseTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.exerciseCellIdentifier, for: indexPath) as! CDExerciseTableViewCell
            
            return cell
        } else if tableView == goalsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.goalCellIdentifier, for: indexPath) as! CDGoalTableViewCell
            
            let goalString = "\(indexPath.row). \(goalList[indexPath.row].entry ?? "default goal")"
            let achieveString = "achieved: \(goalList[indexPath.row].achieved)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .short
            let date = dateFormatter.string(from: goalList[indexPath.row].date)

            let dateString = "date: \(date)"
            
            cell.updateCell(goal: goalString, achieve: achieveString, date: dateString)
            
            return cell
        } else if tableView == wellnessTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.wellnessCellIdentifier, for: indexPath) as! CDWellnessTableViewCell
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == exerciseTable {
            
        } else if tableView == goalsTable {
            selectedGoalIndex = indexPath.row
        } else if tableView == wellnessTable {
            
        }
    }
}

extension CoreDataViewController {
    
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
            self.addGoal(achieved: false, entry: goalText)
            self.getData()
            self.goalsTable.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func removeGoalsCell(_ sender: UIButton) {
        print("remove goals cells")
        clearIndexedEntityData(selectedGoalIndex ?? 1000, entityName: "Goal")
        self.getData()
        self.goalsTable.reloadData()
    }
    
    @objc func resetGoalsCells(_ sender: UIButton) {
        print("reset goals cells")
        clearAllEntityData(entityName: "Goal")
        self.getData()
        self.goalsTable.reloadData()
    }
    
    @objc func addExerciseCell(_ sender: UIButton) {
        print("add exercise cell")
    }
    
    @objc func removeExerciseCell(_ sender: UIButton) {
        print("remove exercise cell")
    }
    
    @objc func resetExerciseCells(_ sender: UIButton) {
        print("reset exercise cells")
    }
    
    @objc func addWellnessCell(_ sender: UIButton) {
        print("add wellness cell")
    }
    
    @objc func removeWellnessCell(_ sender: UIButton) {
        print("remove wellness cell")
    }
    
    @objc func resetWellnessCells(_ sender: UIButton) {
        print("reset wellness cells")
    }
}

extension CoreDataViewController {

    // general data management helper functions
    func clearAllEntityData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try context.fetch(fetchRequest) as! [NSManagedObject]
            if items.count > 0 {
                for index in 0..<items.count {
                    context.delete(items[index])
                }
            try context.save()
            }
        } catch {
            print("Failed saving")
        }
    }
    
    func clearIndexedEntityData(_ index: Int, entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try context.fetch(fetchRequest) as! [NSManagedObject]
            if items.count > index {
                context.delete(items[index])
            }
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getData() {
        do {
            goalList = try context.fetch(Goal.fetchRequest())
            print("Fetched goals successfully")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension CoreDataViewController {
    // goal data management
    func addGoal(achieved: Bool, entry: String) {
        let goal = Goal(entity: Goal.entity(), insertInto: context)
        goal.achieved = achieved
        goal.entry = entry
        goal.date = Date()
        
        context.insert(goal)
        
        do {
            try context.save()
            print("Goal saved")
        } catch {
            print("Failed saving")
        }
    }
}
