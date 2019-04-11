//
//  ProgressViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import Charts

class ProgressViewController: UIViewController {

    let colorTheme = UIColor(named: "green")!
    
    // Subviews
    let headerView = Header()
    let progressGraph = LineChartView()
    let exerciseProgressList = UITableView()
    
    // chart setup variables
    var lineChartEntry = [ChartDataEntry]()
    var x_axis = [Float]()
    var y_prog = [Float]()
    
    // load these variables with core data
    var exerciseNames = [String]()
    let progressCellIdentifier = "progressCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.selectedImage = UIImage(named: "progress")!
        self.tabBarItem.title = "Progress"
        
        exerciseProgressList.delegate = self
        exerciseProgressList.dataSource = self
        
        setupViews()
        setupConstraints()
        
        self.view.layoutIfNeeded()
//        showBorder(view: progressGraph)
//        showBorder(view: exerciseProgressList)
        
        for _ in 0..<200 {
            x_axis.append(Float.random(in: 0...200))
            y_prog.append(Float.random(in: 0...1))
        }
        x_axis.sort()
//        y_prog.sort()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        exerciseNames.removeAll()
        
        reloadExerciseData()
        
        for exercise in exercises {
            exerciseNames.append(exercise.name)
        }
        
        exerciseProgressList.reloadData()
        
        updateGraph()
    }
    
    @IBAction func unwindToProgressVC(segue: UIStoryboardSegue) {}
}

extension ProgressViewController: UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: self.progressCellIdentifier, for: indexPath) as! ProgressTableViewCell
        
        let colorView = UIView()
        colorView.frame = .zero
        colorView.backgroundColor = .clear
        cell.selectedBackgroundView = colorView
        cell.updateProgressCell(name: exerciseNames[indexPath.row])
        
        return cell
    }
    
//    // sends user to the exercise guide when cell is tapped
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "toExerciseGuide", sender: indexPath.row)
//    }
//
//    // fills exercise guide view controller with information before user is sent there
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if let destination = segue.destination as? ExerciseGuideViewController {
//            if let selectedRow = sender as? Int {
//                destination.colorTheme = colorTheme
//                destination.exerciseName = exerciseNames[selectedRow]
//                destination.exerciseImage = exerciseImages[selectedRow]
//            }
//        }
//    }
}

// MARK: Line chart setup
extension ProgressViewController {
    func updateGraph() {
        for i in 0..<y_prog.count {
            let value = ChartDataEntry(x: Double(x_axis[i]), y: Double(y_prog[i]))
            lineChartEntry.append(value)
        }
        
        let line = LineChartDataSet(values: lineChartEntry, label: "Overall Progress per Session")
        line.colors = [colorTheme.hsbSat(1.0).hsbBrt(0.80)]
        line.circleColors = [colorTheme.hsbSat(1.0).hsbBrt(0.80)]
        line.circleRadius = 3.5
        line.circleHoleRadius = 2
//        line.cubicIntensity = 0.15
        line.mode = .linear//.cubicBezier

        let data = LineChartData()
        data.addDataSet(line)
        
        progressGraph.data = data
        progressGraph.xAxis.labelPosition = .bottom
        progressGraph.scaleYEnabled = false
        progressGraph.animate(yAxisDuration: 2.0, easingOption: .easeOutCubic)
        progressGraph.xAxis.drawAxisLineEnabled = true
        progressGraph.xAxis.drawGridLinesEnabled = false
        progressGraph.xAxis.drawLimitLinesBehindDataEnabled = false
        progressGraph.xAxis.drawLabelsEnabled = true
        progressGraph.xAxis.avoidFirstLastClippingEnabled = true
        progressGraph.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
        progressGraph.zoom(scaleX: CGFloat(y_prog.count) / 10, scaleY: 1.0, x: 0, y: 0)
        progressGraph.moveViewToX(Double(y_prog.count))
    }
}

extension ProgressViewController: ViewConstraintProtocol {
    internal func setupViews() {
        headerView.updateHeader(text: "Progress", color: colorTheme, fsize: 30)
        self.view.addSubview(headerView)
        
        self.view.addSubview(progressGraph)
        
        exerciseProgressList.frame = .zero
        exerciseProgressList.backgroundColor = .clear
        exerciseProgressList.rowHeight = 50
        exerciseProgressList.register(ProgressTableViewCell.self, forCellReuseIdentifier: self.progressCellIdentifier)
        self.view.addSubview(exerciseProgressList)
    }
    
    internal func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 140.0).isActive = true
        
        progressGraph.translatesAutoresizingMaskIntoConstraints = false
        progressGraph.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        progressGraph.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        progressGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        progressGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        exerciseProgressList.translatesAutoresizingMaskIntoConstraints = false
        exerciseProgressList.topAnchor.constraint(equalTo: progressGraph.bottomAnchor, constant: 20).isActive = true
        exerciseProgressList.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        exerciseProgressList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        exerciseProgressList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
}
