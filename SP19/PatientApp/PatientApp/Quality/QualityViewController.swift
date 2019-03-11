//
//  QualityViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class QualityViewController: UIViewController {
    
    let colorTheme = UIColor(named: "purple")!
    var questionList: [String] = ["Do you have pain?",
                                  "Do you have tightness?",
                                  "Do you have anxiety pain?",
                                  "Can you put on your shirt without assistance?",
                                  "Can you put on your pants without assistance?",
                                  "Can you comb your hair without assistance?",
                                  "Can you shower without assistance?",
                                  "Can you use the toilet without assistance?",
                                  "Can you perform light cooking without assistance?",
                                  "Can you perform light house cleaning without assistance?"]
    var isSliderQuestionList: [Bool] = [true, true, true, false, false, false, false, false, false, false]
    var questionViewList = [YNSliderQuestion]()
    
    // Subviews
    let headerView = Header()
    let questionScrollView = UIScrollView()
    let questionStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addViews()
        setupConstraints()
        
//        self.view.layoutIfNeeded()
//        showBorder(view: questionStackView)
//        for i in questionViewList {
//            showBorder(view: i)
//        }
    }
    
    private func setupViews() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.headerString = "Questionnaire"
        headerView.headerColor = colorTheme
        headerView.updateHeader()
        
        for i in 0..<questionList.count {
            questionViewList.append(YNSliderQuestion())
            
            questionViewList[i].translatesAutoresizingMaskIntoConstraints = false
            questionViewList[i].frame = .zero
            questionViewList[i].backgroundColor = .clear
            questionViewList[i].colorTheme = colorTheme
            questionViewList[i].questionNumber = i + 1
            questionViewList[i].question = questionList[i]
            questionViewList[i].isSlider = isSliderQuestionList[i]
            questionViewList[i].updateQuestion()

            questionStackView.insertArrangedSubview(questionViewList[i], at: i)

            if isSliderQuestionList[i] {
                questionViewList[i].heightAnchor.constraint(equalToConstant: 120).isActive = true
            } else {
                questionViewList[i].heightAnchor.constraint(equalToConstant: 70).isActive = true
            }
            questionViewList[i].leadingAnchor.constraint(equalTo: questionStackView.leadingAnchor).isActive = true
            questionViewList[i].trailingAnchor.constraint(equalTo: questionStackView.trailingAnchor).isActive = true
        }
        questionViewList[0].yesButton.addTarget(self, action: #selector(yesPressed), for: .touchUpInside)
        questionViewList[0].noButton.addTarget(self, action: #selector(noPressed), for: .touchUpInside)
        
        questionStackView.translatesAutoresizingMaskIntoConstraints = false
        questionStackView.axis = .vertical
//        questionStackView.distribution = .fillEqually
//        questionStackView.alignment = .fill
        questionStackView.spacing = 0
        
        questionScrollView.translatesAutoresizingMaskIntoConstraints = false
        questionScrollView.backgroundColor = .clear
        questionScrollView.contentSize.height = 1500
        questionScrollView.contentSize.width = questionStackView.frame.width
    }
    
    private func addViews() {
        self.view.addSubview(headerView)
        self.view.addSubview(questionScrollView)
        questionScrollView.addSubview(questionStackView)
    }
    
    private func setupConstraints() {
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        questionScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        questionScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        questionScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        questionScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        questionStackView.topAnchor.constraint(equalTo: questionScrollView.topAnchor, constant: 10).isActive = true
        questionStackView.bottomAnchor.constraint(equalTo: questionScrollView.bottomAnchor).isActive = true
        questionStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        questionStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
    
    @objc func yesPressed(_ sender: UIButton) {
        print("yeet")
    }
    
    @objc func noPressed(_ sender: UIButton) {
        print ("this bitch empty")
    }
}
