//
//  ProgressViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import Charts

class ProgressViewController: UIViewController, ChartViewDelegate {

    let colorTheme = UIColor(named: "green")!
    
    // Subviews
    let headerView = Header()
    let progressGraph = CombinedChartView()
    let exerciseTitle = UILabel()
    let exerciseField = UITextField()
    let exercisePicker = UIPickerView()
    
    let romView = MetricView()
    let repView = MetricView()
    let slouchView = MetricView()
    let compView = MetricView()
    
    // chart setup variables
    var sessions = [Float]()
    var romValues = [Float]()
    var repValues = [Int16]()
    var romChartEntry = [ChartDataEntry]()
    var repChartEntry = [BarChartDataEntry]()

    let progressCellIdentifier = "progressCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.selectedImage = UIImage(named: "progress")!
        self.tabBarItem.title = "Progress"
        
        reloadExerciseData()
        
        updateMetricViews(exercise: exercises[0])
        
        setupViews()
        setupConstraints()
        
        for i in 0..<10 {
            sessions.append(Float(i))
            romValues.append(Float.random(in: 0...75))
            repValues.append(Int16.random(in: 0...10))
        }
        sessions.sort()
        romValues.sort()
        repValues.sort()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
        
        progressGraph.delegate = self
        progressGraph.noDataText = "You need to provide data for the chart."
        progressGraph.drawBarShadowEnabled = false
        
        // x axis
        progressGraph.xAxis.labelPosition = .bottom
        progressGraph.xAxis.drawAxisLineEnabled = false
        progressGraph.xAxis.drawGridLinesEnabled = false
        progressGraph.xAxis.drawLimitLinesBehindDataEnabled = false
        progressGraph.xAxis.drawLabelsEnabled = true
        progressGraph.xAxis.avoidFirstLastClippingEnabled = true
        
        // left axis
        progressGraph.leftAxis.labelPosition = .outsideChart
        progressGraph.leftAxis.axisMinimum = 0.0
        progressGraph.leftAxis.axisMaximum = 105.0
        progressGraph.leftAxis.drawAxisLineEnabled = false
        progressGraph.leftAxis.drawGridLinesEnabled = true
        progressGraph.leftAxis.granularityEnabled = true
        progressGraph.leftAxis.granularity = 100/(5-1)
        
        // right axis
        progressGraph.rightAxis.labelPosition = .outsideChart
        progressGraph.rightAxis.axisMinimum = 0.0
        progressGraph.rightAxis.axisMaximum = 21.0
        progressGraph.rightAxis.drawAxisLineEnabled = false
        progressGraph.rightAxis.drawGridLinesEnabled = false
        progressGraph.rightAxis.granularityEnabled = true
        progressGraph.rightAxis.granularity = 20/(5-1)
        
        progressGraph.scaleYEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadExerciseData()
        
        updateGraph(exercises[0])
    }
    
    @IBAction func unwindToProgressVC(segue: UIStoryboardSegue) {}
}

// MARK: button actions
extension ProgressViewController {
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}

// MARK: Line chart setup
extension ProgressViewController {
    func updateGraph(_ exercise: Exercise) {
        // update historical data for displayExercise
        
        for i in 0..<sessions.count {
            romChartEntry.append( ChartDataEntry(x: Double(sessions[i]), y: Double(romValues[i])) )
            repChartEntry.append( BarChartDataEntry(x: Double(sessions[i]), y: Double(repValues[i])) )
        }
        
        let romSet = LineChartDataSet(values: romChartEntry, label: "Maximum Range of Motion")
        romSet.axisDependency = .left
        romSet.colors = [colorTheme.hsbSat(1.0).hsbBrt(0.80)]
        romSet.circleColors = [colorTheme.hsbSat(1.0).hsbBrt(0.50)]
        romSet.circleRadius = 2
        romSet.drawCircleHoleEnabled = false
        romSet.mode = .linear
        romSet.drawValuesEnabled = true

        let lineData = LineChartData(dataSets: [romSet])
        
        let repSet = BarChartDataSet(values: repChartEntry, label: "Number of Repetitions")
        repSet.axisDependency = .right
        repSet.colors = [colorTheme.hsbSat(1.0).hsbBrt(1.0)]
        repSet.drawValuesEnabled = true
        
        let barData = BarChartData(dataSets: [repSet])
        
        let data = CombinedChartData()
        data.lineData = lineData
        data.barData = barData
        
        progressGraph.data = data
        progressGraph.moveViewToX(Double(sessions.count))
        progressGraph.animate(yAxisDuration: 2.0, easingOption: .easeOutCubic)
        progressGraph.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
        progressGraph.zoom(scaleX: CGFloat(sessions.count) / 10, scaleY: 1.0, x: 0, y: 0)
    }
}

extension ProgressViewController: ViewConstraintProtocol, UITextFieldDelegate {
    internal func setupViews() {
        headerView.updateHeader(text: "Progress", color: colorTheme, fsize: 30)
        self.view.addSubview(headerView)
        
        exerciseTitle.setLabelParams(color: .gray, string: "Pick exercise:", ftype: defFont, fsize: 14, align: .center)
        self.view.addSubview(exerciseTitle)
        
        exerciseField.setTextFieldParams(color: .gray, bgColor: .clear, string: exercises[0].name, ftype: defFont, fsize: 24, align: .right)
        exerciseField.inputView = exercisePicker
        exerciseField.delegate = self
        self.view.addSubview(exerciseField)
        
        exercisePicker.delegate = self
        exercisePicker.dataSource = self
        
        self.view.addSubview(progressGraph)
        
        self.view.addSubview(romView)
        self.view.addSubview(repView)
        self.view.addSubview(slouchView)
        self.view.addSubview(compView)
    }
    
    internal func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 140.0).isActive = true
        
        exerciseField.translatesAutoresizingMaskIntoConstraints = false
        exerciseField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        exerciseField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 120).isActive = true
        exerciseField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        exerciseField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        exerciseTitle.translatesAutoresizingMaskIntoConstraints = false
        exerciseTitle.centerYAnchor.constraint(equalTo: exerciseField.centerYAnchor).isActive = true
        exerciseTitle.heightAnchor.constraint(equalTo: exerciseField.heightAnchor).isActive = true
        exerciseTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        exerciseTitle.trailingAnchor.constraint(equalTo: exerciseField.leadingAnchor).isActive = true
        
        progressGraph.translatesAutoresizingMaskIntoConstraints = false
        progressGraph.topAnchor.constraint(equalTo: exerciseField.bottomAnchor, constant: 20).isActive = true
        progressGraph.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        progressGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        progressGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        romView.translatesAutoresizingMaskIntoConstraints = false
        romView.topAnchor.constraint(equalTo: progressGraph.bottomAnchor, constant: 20).isActive = true
        romView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        romView.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10).isActive = true
        romView.heightAnchor.constraint(equalTo: slouchView.heightAnchor).isActive = true
        
        repView.translatesAutoresizingMaskIntoConstraints = false
        repView.centerYAnchor.constraint(equalTo: romView.centerYAnchor).isActive = true
        repView.leadingAnchor.constraint(equalTo: romView.trailingAnchor, constant: 20).isActive = true
        repView.widthAnchor.constraint(equalTo: romView.widthAnchor).isActive = true
        repView.heightAnchor.constraint(equalTo: romView.heightAnchor).isActive = true
        
        slouchView.translatesAutoresizingMaskIntoConstraints = false
        slouchView.leadingAnchor.constraint(equalTo: romView.leadingAnchor).isActive = true
        slouchView.trailingAnchor.constraint(equalTo: romView.trailingAnchor).isActive = true
        slouchView.topAnchor.constraint(equalTo: romView.bottomAnchor, constant: 20).isActive = true
        slouchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        
        compView.translatesAutoresizingMaskIntoConstraints = false
        compView.centerYAnchor.constraint(equalTo: slouchView.centerYAnchor).isActive = true
        compView.leadingAnchor.constraint(equalTo: slouchView.trailingAnchor, constant: 20).isActive = true
        compView.widthAnchor.constraint(equalTo: slouchView.widthAnchor).isActive = true
        compView.heightAnchor.constraint(equalTo: slouchView.heightAnchor).isActive = true
    }
}

extension ProgressViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercises[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        exerciseField.text = exercises[row].name
        updateGraph(exercises[row])
        updateMetricViews(exercise: exercises[row])
    }
    
    func updateMetricViews(exercise: Exercise) {
//        var metaArray = Array(exercise.meta)
//        if metaArray.count > 1 {
//            metaArray.sort(by: { $0.max > $1.max })
//            romView.updateView(top: "Widest range of motion:", metric: "\(String(format: "%.0f", metaArray[0].max))º", bottom: "")
//            metaArray.sort(by: { $0.reps > $1.reps })
//            repView.updateView(top: "In a single session, you can do", metric: "\(metaArray[0].reps) reps", bottom: "")
//            metaArray.sort(by: { $0.slouch > $1.slouch })
//            slouchView.updateView(top: "Your posture has improved by", metric: "\(String(format: "%.2f", metaArray[0].slouch * 100))%", bottom: "")
//            metaArray.sort(by: { $0.comp > $1.comp })
//            compView.updateView(top: "You are as strong as", metric: "\(String(format: "%.0f", metaArray[0].comp * 100)) ducks", bottom: "")
//        } else if metaArray.count == 1 {
//            romView.updateView(top: "You can move your arm", metric: "\(String(format: "%.0f", metaArray[0].max))º", bottom: "since you've started")
//            repView.updateView(top: "You can already do", metric: "\(metaArray[0].reps) reps", bottom: "in a single session")
//            slouchView.updateView(top: "Your posture has improved by", metric: "\(String(format: "%.0f", metaArray[0].slouch * 100))%", bottom: "")
//            compView.updateView(top: "You are as strong as", metric: "\(String(format: "%.0f", metaArray[0].comp * 100)) ducks", bottom: "")
//        } else {
//            romView.updateView(top: "", metric: "No data", bottom: "")
//            repView.updateView(top: "", metric: "No data", bottom: "")
//            slouchView.updateView(top: "", metric: "No data", bottom: "")
//            compView.updateView(top: "", metric: "No data", bottom: "")
//        }
        romView.updateView(top: "Widest range of motion:", metric: "75º", bottom: "since you've started")
        repView.updateView(top: "You can already do", metric: "10 reps", bottom: "in a single session")
        slouchView.updateView(top: "Your posture has improved by", metric: "25%", bottom: "")
        compView.updateView(top: "You are as strong as", metric: "95 ducks", bottom: "")
    }
}
