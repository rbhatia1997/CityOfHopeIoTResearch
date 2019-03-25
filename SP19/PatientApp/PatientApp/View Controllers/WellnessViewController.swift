//
//  WellnessViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/18/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class WellnessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // variable to load with core data
    var questionList = [String]()
    var isSliderList = [Bool]()
    var yesNoResults = [Bool]()
    var sliderValues = [Float]()
    
    // private variables
    private let colorTheme = UIColor(named: "purple")!
    private let cellIdentifier: String = "wellnessDatacell"
    
    // subviews
    let headerView = Header()
    let wellnessTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets the tab bar item text and image
        self.tabBarItem.selectedImage = UIImage(named: "wellness")!
        self.tabBarItem.title = "Wellness"
        
        // provide delegate and datasource sources
        wellnessTableView.delegate = self
        wellnessTableView.dataSource = self
        
        // temporarily load the variables manually
        questionList = ["Do you have pain?",
                        "Do you have tightness?",
                        "Do you have anxiety pain?",
                        "Can you put on your shirt without assistance?",
                        "Can you put on your pants without assistance?",
                        "Can you comb your hair without assistance?",
                        "Can you shower without assistance?",
                        "Can you use the toilet without assistance?",
                        "Can you perform light cooking without assistance?",
                        "Can you perform light house cleaning without assistance?"]
        isSliderList = [true, true, true, false, false, false, false, false, false, false]
        yesNoResults = [false, false, false, false, false, false, false, false, false, false]
        sliderValues = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
        
        // calls everything
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        // setup the table view
        wellnessTableView.frame = .zero
        wellnessTableView.backgroundColor = .clear
        wellnessTableView.register(WellnessTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        // update the header view
        headerView.updateHeader(text: "Workouts", color: colorTheme, fsize: 30)
        
        // add the subviews to the main view
        self.view.addSubview(headerView)
        self.view.addSubview(wellnessTableView)
    }
    
    private func setupConstraints() {
        // set up header view constraints
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // setup table view constraints
        wellnessTableView.translatesAutoresizingMaskIntoConstraints = false
        wellnessTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        wellnessTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        wellnessTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        wellnessTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    // required for table: number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // required for table: number of cells in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSliderList[indexPath.row] {
            return 120
        } else {
            return 80
        }
    }
    
    // required for table: sets up dequeue for cell, fills each cell with information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! WellnessTableViewCell
        
        let colorView = UIView()
        colorView.frame = .zero
        colorView.backgroundColor = .clear
        cell.selectedBackgroundView = colorView
        cell.updateQuestionCell(color: colorTheme,
                                questionNum: (indexPath.row + 1),
                                text: questionList[indexPath.row],
                                slider: isSliderList[indexPath.row],
                                yes: yesNoResults[indexPath.row],
                                sliderVal: sliderValues[indexPath.row])
//        cell.isSlider = Master.WellnessVars.isSliderList[indexPath.row]
//        print("\(indexPath.row): \(cell.isSlider ?? true)")
//        cell.setNeedsDisplay()
        
//        WellnessVars.yesNoResults[indexPath.row] = cell.getYN()
//        print(WellnessVars.yesNoResults[0])
//        WellnessVars.sliderValues[indexPath.row] = cell.getSlider()
        
        return cell
    }

}
