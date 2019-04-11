//
//  OverallProgressGraph.swift
//  PatientApp
//
//  Created by Darien Joso on 3/17/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

//import UIKit
//import Charts
//
//class OverallProgressView: UIView {
//
//    var values = [Float]()
//    var colorTheme = UIColor()
//
//    init() {
//        super.init(frame: .zero)
//        self.backgroundColor = .clear
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func updateGraph(val: [Float], color: UIColor) {
//        values = val
//        colorTheme = color
//
//        setup()
//    }
//
//    func setup() {
//        var lineChartEntry = [ChartDataEntry]()
//
//        for i in 0..<20 {
//            let value = ChartDataEntry(x: Double(i), y: Double(values[i]))
//            lineChartEntry.append(value)
//        }
//
//        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number")
//        line1.colors = [colorTheme]
//
//        let data = LineChartData()
//        data.addDataSet(line1)
//
//    }
//}
