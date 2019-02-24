//
//  HomeScreenViewController.swift
//  COHPatientUI
//
//  Created by Darien Joso on 2/21/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import Charts

class HomeScreenViewController: UIViewController {

    // Outlets
    @IBOutlet weak var moodRating: MoodRating!
    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var stepper0: UIStepper!
    @IBOutlet weak var stepper1: UIStepper!
    @IBOutlet weak var stepper2: UIStepper!
    @IBOutlet weak var stepper3: UIStepper!
    @IBOutlet weak var stepper4: UIStepper!
    
    @IBOutlet weak var resetButton: UIButton!
    
    // Data Storage
    var dummyValues = [90.0, 15.0, 40.0, 50.0, 55.0]
    
    var dummyLabels = ["Baseline Stats",
                       "Session 1 Stats",
                       "Session 2 Stats",
                       "Session 3 Stats",
                       "Session 4 Stats"]
    
    var dummyNumber = 5
    
    // Array to store the y values
    var sessionDataArray = [BarChartDataEntry]()
    
    // Array to store the labels of each session
    var sessionLabelArray = [LegendEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Chart has no description
        barChart.chartDescription?.text = ""
        
        // Load the data in proper storage
        for i in 0..<dummyNumber {
            let sessionData = BarChartDataEntry(x: Double(i), y: dummyValues[i])
            
            // Load the dummy data into the data array
            sessionDataArray.append(sessionData)
            
            // Load the legend data into the legend array
            sessionLabelArray.append(LegendEntry.init(label: dummyLabels[i], form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor.black))
            
        }
        
        barChart.legend.entries = sessionLabelArray
        
        updateChartData()
        
        stepper0.value = sessionDataArray[0].y
        stepper1.value = sessionDataArray[1].y
        stepper2.value = sessionDataArray[2].y
        stepper3.value = sessionDataArray[3].y
        stepper4.value = sessionDataArray[4].y
        
        resetButton.setTitle("Reset", for: .normal)
    }
    
    @IBAction func stepper0Step(_ sender: UIStepper) {
        sessionDataArray[0].y = sender.value
        updateChartData()
    }
    
    @IBAction func stepper1Step(_ sender: UIStepper) {
        sessionDataArray[1].y = sender.value
        updateChartData()
    }
    
    @IBAction func stepper2Step(_ sender: UIStepper) {
        sessionDataArray[2].y = sender.value
        updateChartData()
    }
    @IBAction func stepper3Step(_ sender: UIStepper) {
        sessionDataArray[3].y = sender.value
        updateChartData()
    }
    @IBAction func stepper4Step(_ sender: UIStepper) {
        sessionDataArray[4].y = sender.value
        updateChartData()
    }
    
    @IBAction func resetValues(_ sender: UIButton) {
        for i in 0..<dummyNumber {
            sessionDataArray[i].y = dummyValues[i]
        }
        
        stepper0.value = sessionDataArray[0].y
        stepper1.value = sessionDataArray[1].y
        stepper2.value = sessionDataArray[2].y
        stepper3.value = sessionDataArray[3].y
        stepper4.value = sessionDataArray[4].y
        
        updateChartData()
    }
    
    func updateChartData() {
        let chartDataSet = BarChartDataSet(values: sessionDataArray, label: nil)
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(named: "lightskyblue"), UIColor(named: "plum"), UIColor(named: "lightsalmon"), UIColor(named: "lightsalmon"), UIColor(named: "lightsalmon")]
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        barChart.data = chartData
    }

}
