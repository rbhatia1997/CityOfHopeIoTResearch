//
//  ExerciseViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    // load these variables with core data
    var exerciseNames = [String]()
    var exerciseIcons = [UIImage]()
    
    // private variables
    private let colorTheme = UIColor(named: "pink")!
    
    // subviews
    let headerView = Header()
    let exerciseTableView = UITableView()
    
    // global variables
    private let cellIdentifier: String = "exerciseDatacell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets the tab bar item text and image
        self.tabBarItem.selectedImage = UIImage(named: "exercise")!
        self.tabBarItem.title = "Exercise"
        
        // provide delegate and datasource sources
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        
        // calls everything
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        exerciseNames.removeAll()
        exerciseIcons.removeAll()
        
        reloadExerciseData()
        
        for exercise in exercises {
            exerciseNames.append(exercise.name)
            exerciseIcons.append(UIImage(named: exercise.icon) ?? UIImage(named: "replace-me")!)
        }
        
        exerciseTableView.reloadData()
    }
    
    // returns user from exercise guide to main exercise view controller
    @IBAction func unwindToExerciseVC(segue: UIStoryboardSegue) {}
}

extension ExerciseViewController: ViewConstraintProtocol {
    func setupViews() {
        // setup the table view
        exerciseTableView.frame = .zero
        exerciseTableView.backgroundColor = .clear
        exerciseTableView.rowHeight = 120
        exerciseTableView.register(ExerciseTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        exerciseTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.addSubview(exerciseTableView)
        
        // update the header view
        headerView.updateHeader(text: "Workouts", color: colorTheme, fsize: 30)
        self.view.addSubview(headerView)
    }
    
    func setupConstraints() {
        // set up header view constraints
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 140.0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // setup table view constraints
        exerciseTableView.translatesAutoresizingMaskIntoConstraints = false
        exerciseTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        exerciseTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        exerciseTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        exerciseTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension ExerciseViewController: UITableViewDataSource, UITableViewDelegate {
    // required for table: number pof sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // required for table: number of cells in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseNames.count
    }
    
    // required for table: sets up dequeue for cell, fills each cell with information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! ExerciseTableViewCell
        
        let colorView = UIView()
        colorView.frame = .zero
        colorView.backgroundColor = .clear
        cell.selectedBackgroundView = colorView
        cell.updateExerciseCell(color: colorTheme, icon: exerciseIcons[indexPath.row], name: exerciseNames[indexPath.row])
        
        return cell
    }
    
    // sends user to the exercise guide when cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toExerciseGuide", sender: indexPath.row)
    }
    
    // fills exercise guide view controller with information before user is sent there
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? ExerciseGuideViewController {
            if let selectedRow = sender as? Int {
                destination.colorTheme = colorTheme
                destination.exerciseName = exerciseNames[selectedRow]
                destination.exerciseImage = exerciseIcons[selectedRow]
            }
        }
    }
}
