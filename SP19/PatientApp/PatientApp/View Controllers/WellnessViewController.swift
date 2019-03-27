//
//  WellnessViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/18/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class WellnessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewConstraintProtocol {
    
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
    let submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets the tab bar item text and image
        self.tabBarItem.selectedImage = UIImage(named: "wellness")!
        self.tabBarItem.title = "Wellness"
        
        // provide delegate and datasource sources
        wellnessTableView.delegate = self
        wellnessTableView.dataSource = self

        // calls everything
        setupViews()
        setupConstraints()
    }
    
    internal func setupViews() {
        // update the header view
        headerView.updateHeader(text: "Workouts", color: colorTheme, fsize: 30)
        self.view.addSubview(headerView)
        
        // setup the table view
        wellnessTableView.frame = .zero
        wellnessTableView.backgroundColor = .clear
        wellnessTableView.register(WellnessTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        wellnessTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.addSubview(wellnessTableView)
        
        // setup the submit button
        submitButton.setButtonParams(color: .gray, string: "Submit Responses", ftype: "MontserratAlternates-Regular", fsize: 24, align: .center)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        self.view.addSubview(submitButton)
    }
    
    internal func setupConstraints() {
        // set up header view constraints
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: submitButton.frame.height + 20).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        self.view.layoutIfNeeded()
        showBorder(view: submitButton, corner: 5, color: .gray)
        
        // setup table view constraints
        wellnessTableView.translatesAutoresizingMaskIntoConstraints = false
        wellnessTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        wellnessTableView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -20).isActive = true
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
    
    @objc func submitButtonTapped(_ sender: UIButton) {
        print("submit button tapped")
        submitButton.setTitleColor(hsbShadeTint(color: colorTheme, sat: 0.40), for: .normal)
        showBorder(view: submitButton, corner: 5, color: hsbShadeTint(color: colorTheme, sat: 0.40))
        
        let alert = UIAlertController(title: "Responses received!", message: "Thanks for your input!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:
            { action in
                self.submitButton.setTitleColor(.gray, for: .normal)
                showBorder(view: self.submitButton, corner: 5, color: .gray)
        }))
        
        self.present(alert, animated: true)
    }
}

extension WellnessViewController: WellnessTableViewCellDelegate {
    func yesNoInteract(_ tag: Int) {
        print("pressed yesNo button")
//        goalList[tag].achieved = !goalList[tag].achieved
//        getData(entityName: "Goal")
//        wellnessTableView.reloadData()
    }
    
    func sliderInteract(_ tag: Int) {
        print("slider interaction")
    }
    
    
}
