//
//  WellnessTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/10/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class WellnessTableViewCell: UITableViewCell {

    public var colorTheme: UIColor!
    public var questionNumber: Int!
    public var question: String!
    public var isSlider: Bool!
    
    public var boolResult: Bool!
    public var sliderResult: Float!
    
    private var numberLabel = UILabel()
    private var questionLabel = UILabel()
    let yesButton = UIButton()
    let noButton = UIButton()
    private let slider = UISlider()
    private let minLabel = UILabel()
    private let midLabel = UILabel()
    private let maxLabel = UILabel()
    
    var wellnessCellDelegate: WellnessTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateQuestionCell(color: UIColor, questionNum: Int, text: String, slider: Bool, yes: Bool, sliderVal: Float) {
        colorTheme = color
        questionNumber = questionNum
        question = text
        isSlider = slider
        boolResult = yes
        sliderResult = sliderVal
        setupViews()
        setupConstraints()
    }
    
    func yesButtonPressed(_ tag: Int) {
        boolResult = true
        updateQuestionCell(color: colorTheme, questionNum: questionNumber, text: question,
                           slider: isSlider, yes: boolResult, sliderVal: sliderResult)
    }
    
    func noButtonPressed(_ tag: Int) {
        boolResult = false
        updateQuestionCell(color: colorTheme, questionNum: questionNumber, text: question,
                           slider: isSlider, yes: boolResult, sliderVal: sliderResult)
    }
    
    func sliderTouched(_ tag: Int) {
//        sliderResult =
        updateQuestionCell(color: colorTheme, questionNum: questionNumber, text: question,
                           slider: isSlider, yes: boolResult, sliderVal: sliderResult)
    }
}

// MARK: button actions
extension WellnessTableViewCell {
    @objc func sliderSlide(_ sender: UISlider) {
        let sliderValue: Float = Float(sender.value.rounded(.up))
        sender.setValue(sliderValue, animated: false)
        wellnessCellDelegate?.sliderInteract(sender.tag)
    }
    
    @objc func yesPressed(_ sender: UIButton) {
        setupCustomButtons(hsbShadeTint(color: colorTheme, sat: 0.3), .gray)
        self.addSubview(yesButton)
        self.addSubview(noButton)
        boolResult = true
        wellnessCellDelegate?.yesNoInteract(sender.tag)
    }
    
    @objc func noPressed(_ sender: UIButton) {
        setupCustomButtons(.gray, hsbShadeTint(color: colorTheme, sat: 0.3))
        self.addSubview(yesButton)
        self.addSubview(noButton)
        boolResult = false
        slider.setValue(0, animated: false)
        wellnessCellDelegate?.yesNoInteract(sender.tag)
    }
}

extension WellnessTableViewCell: ViewConstraintProtocol {
    internal func setupViews() {
        
        numberLabel.setLabelParams(color: .gray, string: "\(questionNumber ?? 99).", ftype: "MontserratAlternates-Regular", fsize: 16, align: .left)
        questionLabel.setLabelParams(color: .gray, string: question, ftype: "MontserratAlternates-Regular", fsize: 16, align: .left)
        
        let yesColor: UIColor!
        let noColor: UIColor!
        
        if boolResult {
            yesColor = hsbShadeTint(color: colorTheme, sat: 0.3)
            noColor = .gray
        } else {
            yesColor = .gray
            noColor = hsbShadeTint(color: colorTheme, sat: 0.3)
        }
        
        setupCustomButtons(yesColor, noColor)

        self.addSubview(numberLabel)
        self.addSubview(questionLabel)
        self.addSubview(yesButton)
        self.addSubview(noButton)
        
        if isSlider {
            slider.frame = CGRect(x: 0, y: 0, width: 250, height: 35)
            slider.minimumTrackTintColor = hsbShadeTint(color: colorTheme, sat: 0.3)
            slider.maximumTrackTintColor = nil
            slider.thumbTintColor = nil
            slider.maximumValue = 10
            slider.minimumValue = 0
            slider.setValue(sliderResult, animated: false)
            slider.tag = 99
            slider.addTarget(self, action: #selector(sliderSlide), for: .valueChanged)
            
            minLabel.setLabelParams(color: .gray, string: "0", ftype: "Montserrat-Regular", fsize: 14, align: .center, tag: 99)
            midLabel.setLabelParams(color: .gray, string: "5", ftype: "Montserrat-Regular", fsize: 14, align: .center, tag: 99)
            maxLabel.setLabelParams(color: .gray, string: "10", ftype: "Montserrat-Regular", fsize: 14, align: .center, tag: 99)
            
            self.addSubview(slider)
            self.addSubview(minLabel)
            self.addSubview(midLabel)
            self.addSubview(maxLabel)
        } else {
            if let viewWithTag = slider.viewWithTag(99) {
                minLabel.viewWithTag(99)?.removeFromSuperview()
                midLabel.viewWithTag(99)?.removeFromSuperview()
                maxLabel.viewWithTag(99)?.removeFromSuperview()
                viewWithTag.removeFromSuperview()
            }
        }
    }
    
    private func setupCustomButtons(_ yesColor: UIColor, _ noColor: UIColor) {
        yesButton.setButtonParams(color: yesColor, string: "Yes", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        yesButton.addTarget(self, action: #selector(yesPressed), for: .touchUpInside)
        
        noButton.setButtonParams(color: noColor, string: "No", ftype: "Montserrat-Regular", fsize: 16, align: .center)
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
    
    internal func setupConstraints() {
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: numberLabel.frame.height).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        numberLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.topAnchor.constraint(equalTo: numberLabel.topAnchor).isActive = true
        questionLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor).isActive = true
        questionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.topAnchor.constraint(equalTo: numberLabel.topAnchor).isActive = true
        noButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        noButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        noButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.topAnchor.constraint(equalTo: numberLabel.topAnchor).isActive = true
        yesButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        yesButton.trailingAnchor.constraint(equalTo: noButton.leadingAnchor, constant: -10).isActive = true
        yesButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        if isSlider {
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            slider.widthAnchor.constraint(equalToConstant: slider.frame.width).isActive = true
            slider.topAnchor.constraint(equalTo: questionLabel.topAnchor, constant: 50).isActive = true
            slider.heightAnchor.constraint(equalToConstant: slider.frame.height).isActive = true
            
            minLabel.translatesAutoresizingMaskIntoConstraints = false
            minLabel.centerXAnchor.constraint(equalTo: slider.leadingAnchor).isActive = true
            minLabel.widthAnchor.constraint(equalToConstant: minLabel.frame.width).isActive = true
            minLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            minLabel.heightAnchor.constraint(equalToConstant: minLabel.frame.height).isActive = true
            
            midLabel.translatesAutoresizingMaskIntoConstraints = false
            midLabel.centerXAnchor.constraint(equalTo: slider.centerXAnchor).isActive = true
            midLabel.widthAnchor.constraint(equalToConstant: midLabel.frame.width).isActive = true
            midLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            midLabel.heightAnchor.constraint(equalToConstant: midLabel.frame.height).isActive = true
            
            maxLabel.translatesAutoresizingMaskIntoConstraints = false
            maxLabel.centerXAnchor.constraint(equalTo: slider.trailingAnchor).isActive = true
            maxLabel.widthAnchor.constraint(equalToConstant: maxLabel.frame.width).isActive = true
            maxLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            maxLabel.heightAnchor.constraint(equalToConstant: maxLabel.frame.height).isActive = true
        }
    }
}
