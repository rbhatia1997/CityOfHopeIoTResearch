//
//  CoreDataViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/23/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
// template for entity selection
//if entitySelection.selectedSegmentIndex == 0 {
//
//} else if entitySelection.selectedSegmentIndex == 1 {
//
//} else if entitySelection.selectedSegmentIndex == 2 {
//
//} else if entitySelection.selectedSegmentIndex == 3 {
//
//} else if entitySelection.selectedSegmentIndex == 4 {
//
//} else {
//
//}

import UIKit
import CoreData

class CDViewController: UIViewController {

    private let colorTheme: UIColor = hsbShadeTint(color: .orange, sat: 0.50)
    // global variable
    var selectedRowIndex: Int = largeNumber
    var selectedSectionIndex: Int = largeNumber
    
    // subviews
    let headerView = Header()

    // construction variables
    let homeButton = UIButton()
    
    let entitySelection = UISegmentedControl(items: ["Exercises", "Meta", "Processed", "Goals", "Questions", "Responses"])
    let fakeButton = UIButton()
    let loadButton = UIButton()
    let resetButton = UIButton()
    let addButton = UIButton()
    let removeButton = UIButton()
    let dataTable = UITableView()
    let cellIdentifier = "coreDataCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTable.delegate = self
        dataTable.dataSource = self
        
        dataTable.register(CDTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataTable.rowHeight = 110
        
        reloadAllExerciseData()
        dataTable.reloadData()
    }
}

// MARK: pass data to cells
extension CDViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if entitySelection.selectedSegmentIndex == 0 {
            return exercises.count
        } else if entitySelection.selectedSegmentIndex == 1 {
            return exerciseMetas[section].count
        } else if entitySelection.selectedSegmentIndex == 2 {
            return exerciseProcessed[section].count
        } else if entitySelection.selectedSegmentIndex == 3 {
            return goals.count
        } else if entitySelection.selectedSegmentIndex == 4 {
            return questions.count
        } else if entitySelection.selectedSegmentIndex == 5 {
            return questionResponses[section].count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CDTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .short
        
        var dateString = String()
        var data0String = String()
        var data1String = String()
        var data2String = String()
        
        if entitySelection.selectedSegmentIndex == 0 {
            
            dateString = "id: \(exercises[indexPath.row].id)"
            data0String = "name: \(exercises[indexPath.row].name)"
            data1String = "meta count: \(exercises[indexPath.row].meta.count)"
            data2String = "use: \(exercises[indexPath.row].use)"
            
        } else if entitySelection.selectedSegmentIndex == 1 {

            dateString = "id: \(exerciseMetas[indexPath.section][indexPath.row].id)"
            data0String = "max rom: \(exerciseMetas[indexPath.section][indexPath.row].rom.max() ?? 0)"
            data1String = "processed id: \(exerciseMetas[indexPath.section][indexPath.row].processed?.id ?? "no processed")"
            data2String = "exercise name: \(exerciseMetas[indexPath.section][indexPath.row].exercise?.name ?? "no exercise")"
            
        } else if entitySelection.selectedSegmentIndex == 2 {

            dateString = "id: \(exerciseProcessed[indexPath.section][indexPath.row].id)"
            data0String = "data count: \(exerciseProcessed[indexPath.section][indexPath.row].q_gb.count)"
            data1String = "timestep count: \(exerciseProcessed[indexPath.section][indexPath.row].timestep.count)"
            data2String = "meta id: \(exerciseProcessed[indexPath.section][indexPath.row].meta?.id ?? "no meta")"
            
        } else if entitySelection.selectedSegmentIndex == 3 {
            
            dateString = "id: \(goals[indexPath.row].id)"
            data0String = "text: \(goals[indexPath.row].text)"
            data1String = "bool: \(goals[indexPath.row].bool)"
            data2String = ""

        } else if entitySelection.selectedSegmentIndex == 4 {
            
            dateString = "id: \(questions[indexPath.row].id)"
            data0String = "text: \(questions[indexPath.row].text)"
            data1String = "bool: \(questions[indexPath.row].bool)"
            data2String = "response: \(questions[indexPath.row].response)"
            
        } else if entitySelection.selectedSegmentIndex == 5 {

            dateString = "id: \(questionResponses[indexPath.section][indexPath.row].id)"
            data0String = "value: \(questionResponses[indexPath.section][indexPath.row].value)"
            data1String = "bool: \(questionResponses[indexPath.section][indexPath.row].bool)"
            data2String = "question: \(questionResponses[indexPath.section][indexPath.row].question?.text ?? "no question")"
            
        } else {
            return UITableViewCell()
        }
        
        cell.updateCell(date: dateString, data0: data0String, data1: data1String, data2: data2String)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedRowIndex == indexPath.row  && selectedSectionIndex == indexPath.section {
            selectedRowIndex = largeNumber
            selectedSectionIndex = largeNumber
            dataTable.deselectRow(at: indexPath, animated: false)
        } else {
            selectedRowIndex = indexPath.row
            selectedSectionIndex = indexPath.section
        }
    }
}



// MARK: button actions
extension CDViewController {
    @objc func homeButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHomeVCFromCDVC", sender: sender)
    }
    
    @objc func entitySelectionTapped(_ sender: UISegmentedControl) {
        switch entitySelection.selectedSegmentIndex {
        case 0: // exercise
            reloadAllExerciseData()
            dataTable.reloadData()
        case 1: // goal
            reloadAllExerciseMetaData()
            dataTable.reloadData()
        case 2: // processed
            reloadAllExerciseProcessedData()
            dataTable.reloadData()
        case 3: // goal
            reloadGoalData()
            dataTable.reloadData()
        case 4: // question
            reloadQuestionData()
            dataTable.reloadData()
        case 5: // response
            reloadQuestionResponseData()
            dataTable.reloadData()
        default:
            print("No entity selected")
            reloadAllExerciseData()
            dataTable.reloadData()
        }
    }
    
    @objc func loadData(_ sender: UIButton) {
        print("load data")
        if entitySelection.selectedSegmentIndex == 0 {
            for item in presetExerciseList {
                addExerciseData(id: generateID(), name: item.name, image: item.image, icon: item.icon, use: item.use, detection: item.detection)
            }
            reloadAllExerciseData()
        } else if entitySelection.selectedSegmentIndex == 1 {
            let alert = UIAlertController(title: "No Meta data to load", message: "Nothing done", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if entitySelection.selectedSegmentIndex == 2 {
            let alert = UIAlertController(title: "No Processed data to load", message: "Nothing done", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if entitySelection.selectedSegmentIndex == 3 {
            for item in presetGoalList {
                addGoalData(id: generateID(), text: item, bool: false)
            }
            reloadGoalData()
        } else if entitySelection.selectedSegmentIndex == 4 {
            for item in presetQuestionList {
                addQuestionData(id: generateID(), text: item.text, bool: item.bool)
            }
            reloadQuestionData()
        } else if entitySelection.selectedSegmentIndex == 5 {
            let alert = UIAlertController(title: "No Response data to load", message: "Nothing done", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        dataTable.reloadData()
    }

    @objc func fakeData(_ sender: UIButton) {
        print("fake data")
        if entitySelection.selectedSegmentIndex == 0 {
            let alert = UIAlertController(title: "Do not fake Exercise data", message: "Just load Exercise data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if entitySelection.selectedSegmentIndex == 1 {
            let id: String = generateID()
            reloadAllExerciseData()
            var floatArray = [Float]()
            for _ in 0..<5 {
                floatArray.append(Float.random(in: 0...120))
            }
            addMetaData(id: id, rom: floatArray, slouch: Float.random(in: 0...1), comp: Float.random(in: 0...1), exercise: exercises.randomElement(), processed: nil)
            reloadMetaData()
            reloadAllExerciseMetaData()
            addProcessedData(id: id, timestep: srfa(190, 200, 10), q_gb: arrayOfsrfa(0, 100, 3, 10), q_b1: arrayOfsrfa(0, 100, 3, 10), q_b2: arrayOfsrfa(0, 100, 3, 10), q_b3: arrayOfsrfa(0, 100, 3, 10), meta: metas.last!)
            reloadAllExerciseProcessedData()
        } else if entitySelection.selectedSegmentIndex == 2 {
            let alert = UIAlertController(title: "No data to fake", message: "You can fake Meta + Processed data on Meta tab", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if entitySelection.selectedSegmentIndex == 3 {
            let alert = UIAlertController(title: "Do not fake Goal data", message: "Just add or load Goal data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if entitySelection.selectedSegmentIndex == 4 {
            let alert = UIAlertController(title: "Do not fake Question data", message: "Just load Question data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if entitySelection.selectedSegmentIndex == 5 {
            addResponseData(id: generateID(), value: Float(Int.random(in: 0...10)), bool: Bool.random(), question: questions.randomElement())
            reloadQuestionResponseData()
        }
        dataTable.reloadData()
    }
    
    @objc func addData(_ sender: UIButton) {
        print("add data")
        let alert = UIAlertController(title: "No longer functional", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func removeData(_ sender: UIButton) {
        print("remove data")
        if entitySelection.selectedSegmentIndex == 0 {
            deleteExerciseData(selectedRowIndex)
            reloadAllExerciseData()
        } else if entitySelection.selectedSegmentIndex == 1 {
            deleteExerciseMetaData(selectedSectionIndex, selectedRowIndex)
            reloadAllExerciseMetaData()
        } else if entitySelection.selectedSegmentIndex == 2 {
            deleteExerciseProcessedData(selectedSectionIndex, selectedRowIndex)
            reloadAllExerciseProcessedData()
        } else if entitySelection.selectedSegmentIndex == 3 {
            deleteGoalData(selectedRowIndex)
            reloadGoalData()
        } else if entitySelection.selectedSegmentIndex == 4 {
            deleteQuestionData(selectedRowIndex)
            reloadQuestionData()
        } else if entitySelection.selectedSegmentIndex == 5 {
            deleteQuestionResponseData(selectedSectionIndex, selectedRowIndex)
            reloadQuestionResponseData()
        }
        self.dataTable.reloadData()
        selectedRowIndex = largeNumber
    }
    
    @objc func resetData(_ sender: UIButton) {
        print("reset data")
        
        let alert = UIAlertController(title: "Warning", message: "Clear cells?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Proceed", style: .destructive, handler: { action in
            if self.entitySelection.selectedSegmentIndex == 0 {
                clearExerciseData()
                reloadAllExerciseData()
            } else if self.entitySelection.selectedSegmentIndex == 1 {
                clearMetaData()
                reloadAllExerciseMetaData()
            } else if self.entitySelection.selectedSegmentIndex == 2 {
                clearProcessedData()
                reloadAllExerciseProcessedData()
            } else if self.entitySelection.selectedSegmentIndex == 3 {
                clearGoalData()
                reloadGoalData()
            } else if self.entitySelection.selectedSegmentIndex == 4 {
                clearQuestionData()
                reloadQuestionData()
            } else if self.entitySelection.selectedSegmentIndex == 5 {
                clearResponseData()
                reloadQuestionResponseData()
            }
            self.dataTable.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: section header design
extension CDViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        if entitySelection.selectedSegmentIndex == 0 {
            return 1
        } else if entitySelection.selectedSegmentIndex == 1 {
            return exercises.count + 1
        } else if entitySelection.selectedSegmentIndex == 2 {
            return exercises.count + 2
        } else if entitySelection.selectedSegmentIndex == 3 {
            return 1
        } else if entitySelection.selectedSegmentIndex == 4 {
            return 1
        } else if entitySelection.selectedSegmentIndex == 5 {
            return questions.count + 1
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (entitySelection.selectedSegmentIndex == 1) || (entitySelection.selectedSegmentIndex == 2) || (entitySelection.selectedSegmentIndex == 5) {
            let headerView = UIView()
            headerView.backgroundColor = hsbShadeTint(color: colorTheme, sat: 0.20)

            let string = self.tableView(tableView, titleForHeaderInSection: section)!
            let headerLabel = UILabel()
            headerLabel.setLabelParams(color: .gray, string: string, ftype: "MontserratAlternates-Regular", fsize: 15, align: .left)
            headerView.addSubview(headerLabel)

            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 5).isActive = true
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5).isActive = true
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10).isActive = true

            return headerView
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (entitySelection.selectedSegmentIndex == 1) || (entitySelection.selectedSegmentIndex == 2) || (entitySelection.selectedSegmentIndex == 5) {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if entitySelection.selectedSegmentIndex == 1{
            var exerciseString = [String]()
            for exercise in exercises {
                exerciseString.append(exercise.name)
            }
            exerciseString.append("No Exercise")
            return "\(exerciseString[section])"
        } else if entitySelection.selectedSegmentIndex == 2 {
            var exerciseString = [String]()
            for exercise in exercises {
                exerciseString.append(exercise.name)
            }
            exerciseString.append("No Exercise")
            exerciseString.append("No Meta")
            return "\(exerciseString[section])"
        } else if entitySelection.selectedSegmentIndex == 5 {
            reloadQuestionData()
            var questionString = [String]()
            for question in questions {
                questionString.append(question.text)
            }
            questionString.append("No Question")
            return "\(questionString[section])"
        } else {
            return nil
        }
    }
}

// MARK: create UI
extension CDViewController: ViewConstraintProtocol {
    func setupViews() {
        headerView.updateHeader(text: "Core Data", color: hsbShadeTint(color: colorTheme, sat: 0.20), fsize: 30)
        self.view.addSubview(headerView)
        
        homeButton.setButtonParams(color: .gray, string: "Back", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        self.view.addSubview(homeButton)
        
        groupButtonSetup(button: loadButton, text: "Load", action: #selector(loadData))
        groupButtonSetup(button: fakeButton, text: "Fake", action: #selector(fakeData))
        groupButtonSetup(button: addButton, text: "Add", action: #selector(addData))
        groupButtonSetup(button: removeButton, text: "Del", action: #selector(removeData))
        groupButtonSetup(button: resetButton, text: "Reset", action: #selector(resetData))
        
        entitySelection.selectedSegmentIndex = 0
        entitySelection.tintColor = colorTheme
        entitySelection.addTarget(self, action: #selector(entitySelectionTapped), for: .valueChanged)
        self.view.addSubview(entitySelection)
        
        self.view.addSubview(dataTable)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        homeButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        homeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        homeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        entitySelection.translatesAutoresizingMaskIntoConstraints = false
        entitySelection.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        entitySelection.heightAnchor.constraint(equalToConstant: 40).isActive = true
        entitySelection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        entitySelection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        fakeButton.translatesAutoresizingMaskIntoConstraints = false
        fakeButton.topAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        fakeButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        fakeButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        fakeButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10).isActive = true
        
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.topAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        loadButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        loadButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        loadButton.trailingAnchor.constraint(equalTo: fakeButton.leadingAnchor, constant: -10).isActive = true
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.topAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        removeButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        removeButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        removeButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 10).isActive = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.topAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        resetButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        resetButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: removeButton.trailingAnchor, constant: 10).isActive = true
        
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.topAnchor.constraint(equalTo: entitySelection.bottomAnchor, constant: 20).isActive = true
        dataTable.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20).isActive = true
        dataTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        dataTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func groupButtonSetup(button: UIButton, text: String, action: Selector) {
        button.setButtonParams(color: .white, string: text, ftype: "Montserrat-Regular", fsize: 16, align: .center)
        button.setButtonFrame(borderWidth: 1.5, borderColor: colorTheme, cornerRadius: 20, fillColor: colorTheme)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.addTarget(self, action: action, for: .touchUpInside)
        self.view.addSubview(button)
    }
}
