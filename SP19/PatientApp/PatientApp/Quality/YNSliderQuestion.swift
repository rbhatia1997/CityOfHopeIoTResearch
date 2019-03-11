//
//  YNSliderQuestion.swift
//  PatientApp
//
//  Created by Darien Joso on 3/10/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class YNSliderQuestion: UIView {

    var colorTheme = UIColor()
    var questionNumber = Int()
    var question = String()
    var overallBottomAnchor = NSLayoutYAxisAnchor()
    
    var isSlider = Bool()
    private var numberLabel = UILabel()
    private var questionLabel = UILabel()
    let yesButton = UIButton()
    let noButton = UIButton()
    private let slider = UISlider()
    private let minLabel = UILabel()
    private let midLabel = UILabel()
    private let maxLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        colorTheme = .black
        questionNumber = 0
        question = "Replace me with a question."
        isSlider = false
    }
    
    init(isSliderQuestion: Bool, color: UIColor, questNum: Int, quest: String) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        colorTheme = color
        questionNumber = questNum
        question = quest
        isSlider = isSliderQuestion
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(_ numberString: Int, _ questionString: String) {
        numberLabel.frame = .zero
        numberLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 16)
        numberLabel.textColor = .gray
        numberLabel.text = "\(numberString)."
        numberLabel.numberOfLines = 0
        numberLabel.textAlignment = .left
        numberLabel.sizeToFit()
        
        questionLabel.frame = .zero
        questionLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 16)
        questionLabel.textColor = .gray
        questionLabel.text = question
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .left
        questionLabel.sizeToFit()
        
        setupCustomButtons(.gray, .gray)
        
        if isSlider {
            slider.frame = CGRect(x: 0, y: 0, width: 250, height: 35)
            slider.minimumTrackTintColor = hsbShadeTint(color: colorTheme, sat: 0.3)
            slider.maximumTrackTintColor = nil
            slider.thumbTintColor = nil
            slider.maximumValue = 10
            slider.minimumValue = 0
            slider.setValue(5, animated: false)
            slider.addTarget(self, action: #selector(sliderSlide), for: .valueChanged)
            
            minLabel.frame = .zero
            minLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
            minLabel.textColor = .gray
            minLabel.text = "0"
            minLabel.textAlignment = .center
            minLabel.sizeToFit()
            
            midLabel.frame = .zero
            midLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
            midLabel.textColor = .gray
            midLabel.text = "5"
            midLabel.textAlignment = .center
            midLabel.sizeToFit()
            
            maxLabel.frame = .zero
            maxLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
            maxLabel.textColor = .gray
            maxLabel.text = "10"
            maxLabel.textAlignment = .center
            maxLabel.sizeToFit()
        }
    }
    
    private func setupCustomButtons(_ yesColor: UIColor, _ noColor: UIColor) {
        yesButton.frame = .zero
        yesButton.setTitle("Yes", for: .normal)
        yesButton.setTitleColor(yesColor, for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 14.0)
        yesButton.sizeToFit()
        yesButton.titleLabel?.textAlignment = .center
        yesButton.addTarget(self, action: #selector(yesPressed), for: .touchUpInside)
        
        noButton.frame = .zero
        noButton.setTitle("No", for: .normal)
        noButton.setTitleColor(noColor, for: .normal)
        noButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 14.0)
        noButton.sizeToFit()
        noButton.titleLabel?.textAlignment = .center
        noButton.addTarget(self, action: #selector(noPressed), for: .touchUpInside)
        
        let screen = CGRect(x: 0, y: 0, width: 50, height: 30)
        let screenPath = UIBezierPath.init(roundedRect: screen, cornerRadius: 5)
        
        let yesShapeLayer = CAShapeLayer()
        yesShapeLayer.path = screenPath.cgPath
        yesShapeLayer.fillColor = UIColor.clear.cgColor
        yesShapeLayer.strokeColor = yesColor.cgColor
        yesShapeLayer.lineWidth = 1.0
        yesButton.layer.addSublayer(yesShapeLayer)
        
        let noShapeLayer = CAShapeLayer()
        noShapeLayer.path = screenPath.cgPath
        noShapeLayer.fillColor = UIColor.clear.cgColor
        noShapeLayer.strokeColor = noColor.cgColor
        noShapeLayer.lineWidth = 1.0
        noButton.layer.addSublayer(noShapeLayer)
    }
    
    private func addViews() {
        self.addSubview(numberLabel)
        self.addSubview(questionLabel)
        self.addSubview(yesButton)
        self.addSubview(noButton)
        
        if isSlider {
            self.addSubview(slider)
            self.addSubview(minLabel)
            self.addSubview(midLabel)
            self.addSubview(maxLabel)
        }
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: numberLabel.frame.height).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        numberLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        questionLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        questionLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor).isActive = true
//        questionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
//        questionLabel.heightAnchor.constraint(equalToConstant: 1*questionLabel.frame.height).isActive = true

        noButton.centerYAnchor.constraint(equalTo: questionLabel.centerYAnchor).isActive = true
        noButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        noButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        noButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

        yesButton.centerYAnchor.constraint(equalTo: questionLabel.centerYAnchor).isActive = true
        yesButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        yesButton.trailingAnchor.constraint(equalTo: noButton.leadingAnchor, constant: -10).isActive = true
        yesButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        questionLabel.trailingAnchor.constraint(equalTo: yesButton.leadingAnchor, constant: -20).isActive = true
        
        if isSlider {
            slider.translatesAutoresizingMaskIntoConstraints = false
            minLabel.translatesAutoresizingMaskIntoConstraints = false
            midLabel.translatesAutoresizingMaskIntoConstraints = false
            maxLabel.translatesAutoresizingMaskIntoConstraints = false
            
            slider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            slider.widthAnchor.constraint(equalToConstant: slider.frame.width).isActive = true
            slider.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20).isActive = true
            slider.heightAnchor.constraint(equalToConstant: slider.frame.height).isActive = true
            
            minLabel.centerXAnchor.constraint(equalTo: slider.leadingAnchor).isActive = true
            minLabel.widthAnchor.constraint(equalToConstant: minLabel.frame.width).isActive = true
            minLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            minLabel.heightAnchor.constraint(equalToConstant: minLabel.frame.height).isActive = true
            
            midLabel.centerXAnchor.constraint(equalTo: slider.centerXAnchor).isActive = true
            midLabel.widthAnchor.constraint(equalToConstant: midLabel.frame.width).isActive = true
            midLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            midLabel.heightAnchor.constraint(equalToConstant: midLabel.frame.height).isActive = true
            
            maxLabel.centerXAnchor.constraint(equalTo: slider.trailingAnchor).isActive = true
            maxLabel.widthAnchor.constraint(equalToConstant: maxLabel.frame.width).isActive = true
            maxLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            maxLabel.heightAnchor.constraint(equalToConstant: maxLabel.frame.height).isActive = true
            overallBottomAnchor = minLabel.bottomAnchor
        } else {
            overallBottomAnchor = questionLabel.bottomAnchor
        }
    }
    
    func updateQuestion() {
        setupViews(questionNumber, question)
        addViews()
        setupConstraints()
    }
    
    @objc func sliderSlide(_ sender: UISlider) {
        let sliderValue: Float = Float(sender.value.rounded(.up))
        sender.setValue(sliderValue, animated: false)
    }
    
    @objc func yesPressed(_ sender: UIButton) {
        setupCustomButtons(hsbShadeTint(color: colorTheme, sat: 0.3), .gray)
        self.addSubview(yesButton)
        self.addSubview(noButton)
    }
    
    @objc func noPressed(_ sender: UIButton) {
        setupCustomButtons(.gray, hsbShadeTint(color: colorTheme, sat: 0.3))
        self.addSubview(yesButton)
        self.addSubview(noButton)
    }
}
