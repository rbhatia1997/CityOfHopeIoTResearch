//
//  SweepGraph.swift
//  PatientApp
//
//  Created by Darien Joso on 3/14/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class SweepGraph: UIView {
    
    var colorTheme: UIColor!
    var startAngle: CGFloat!
    var maxAngle: CGFloat!
    var rightArm: Bool!
    var currPos: CGFloat! // in radians
    
    // construction variables
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        currPos = 0
    }
    
    init(color: UIColor, start: CGFloat, max: CGFloat, dir: Bool) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        colorTheme = color
        startAngle = start
        maxAngle = max
        rightArm = dir
        currPos = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawSweepGraph(center: CGPoint, color: UIColor, start: CGFloat, value: CGFloat, max: CGFloat, rightArm: Bool, outerDia: CGFloat, innerDia: CGFloat, view: UIView) {
        
        let trackWidth: CGFloat = (outerDia - innerDia)/2
        let trackCenterRadius: CGFloat = (innerDia + trackWidth)/2
        
        let grayPath = UIBezierPath(arcCenter: center,
                                    radius: trackCenterRadius,
                                    startAngle: 0, // in radians
                                    endAngle: 2*CGFloat.pi, // in radians
                                    clockwise: rightArm)
        
        let grayLayer = CAShapeLayer()
        grayLayer.path = grayPath.cgPath
        grayLayer.strokeColor = UIColor(white: 250/255, alpha: 1).cgColor
        grayLayer.lineWidth = trackWidth
        grayLayer.fillColor = UIColor.clear.cgColor
        grayLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(grayLayer)
        
        let trackPath = UIBezierPath(arcCenter: center,
                                     radius: trackCenterRadius,
                                     startAngle: rightArm ? CGFloat.pi/2 + start : CGFloat.pi/2 - start, // in radians
                                     endAngle: rightArm ? CGFloat.pi/2 + max : CGFloat.pi/2 - max, // in radians
                                     clockwise: rightArm)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = color.cgColor
        trackLayer.lineWidth = trackWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
        
        let progPath = UIBezierPath(arcCenter: center,
                                    radius: trackCenterRadius,
                                    startAngle: rightArm ? CGFloat.pi/2 + start : CGFloat.pi/2 - start, // in radians
                                    endAngle: rightArm ? CGFloat.pi/2 + value : CGFloat.pi/2 - value, // in radians
                                    clockwise: rightArm)
        
        let progColor = hsbShadeTint(color: color, sat: 0.40)
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = progPath.cgPath
        progressLayer.strokeColor = progColor.cgColor
        progressLayer.lineWidth = trackWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(progressLayer)
    }
    
    private func setupViews() {
        let outerDia: CGFloat = 200
        let innerDia: CGFloat = outerDia * 0.75
        
        let valueLabel = UILabel()
        valueLabel.frame = .zero
        valueLabel.font = UIFont(name: "Montserrat-ExtraLight", size: innerDia / 4)
        valueLabel.textColor = .black
        valueLabel.text = "\( (currPos * 180 / CGFloat.pi * 10).rounded() / 10 )°"
        valueLabel.sizeToFit()
        valueLabel.textAlignment = .center
        
        self.addSubview(valueLabel)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -60).isActive = true
        
        drawSweepGraph(center: CGPoint(x: valueLabel.frame.width/2, y: valueLabel.frame.height/2),
                       color: colorTheme,
                       start: startAngle,
                       value: currPos,
                       max: maxAngle,
                       rightArm: rightArm,
                       outerDia: outerDia,
                       innerDia: innerDia,
                       view: valueLabel)
        
        if rightArm {
            setupCustomButtons(hsbShadeTint(color: colorTheme, sat: 0.40), .gray)
        } else {
            setupCustomButtons(.gray, hsbShadeTint(color: colorTheme, sat: 0.40))
        }
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
    }
    
    private func setupConstraints() {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60).isActive = true
        leftButton.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60).isActive = true
        rightButton.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
    }
    
    func updateSweepGraph(color: UIColor, start: CGFloat, max: CGFloat, right: Bool, value: CGFloat) {
        colorTheme = color
        startAngle = start
        maxAngle = max
        rightArm = right
        currPos = value
        setupViews()
        setupConstraints()
    }
    
    private func setupCustomButtons(_ leftColor: UIColor, _ rightColor: UIColor) {
        // setup left button
        leftButton.frame = .zero
        leftButton.setTitle("Left-arm \nexercise", for: .normal)
        leftButton.setTitleColor(leftColor, for: .normal)
        leftButton.titleLabel?.numberOfLines = 2
        leftButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)!
        leftButton.sizeToFit()
        leftButton.titleLabel?.textAlignment = .center
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        
        // setup left button
        rightButton.frame = .zero
        rightButton.setTitle("Right-arm \nexercise", for: .normal)
        rightButton.setTitleColor(rightColor, for: .normal)
        rightButton.titleLabel?.numberOfLines = 2
        rightButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)!
        rightButton.sizeToFit()
        rightButton.titleLabel?.textAlignment = .center
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
        
        let leftScreen = CGRect(x: -5 - (rightButton.frame.width - leftButton.frame.width)/2, y: 0, width: rightButton.frame.width + 10, height: leftButton.frame.height)
        let leftScreenPath = UIBezierPath(roundedRect: leftScreen, cornerRadius: 5)
        
        let leftShapeLayer = CAShapeLayer()
        leftShapeLayer.path = leftScreenPath.cgPath
        leftShapeLayer.fillColor = UIColor.clear.cgColor
        leftShapeLayer.strokeColor = leftColor.cgColor
        leftShapeLayer.lineWidth = 0.5
        leftButton.layer.addSublayer(leftShapeLayer)
        
        let rightScreen = CGRect(x: -5, y: 0, width: rightButton.frame.width + 10, height: rightButton.frame.height)
        let rightScreenPath = UIBezierPath(roundedRect: rightScreen, cornerRadius: 5)
        
        let rightShapeLayer = CAShapeLayer()
        rightShapeLayer.path = rightScreenPath.cgPath
        rightShapeLayer.fillColor = UIColor.clear.cgColor
        rightShapeLayer.strokeColor = rightColor.cgColor
        rightShapeLayer.lineWidth = 0.5
        rightButton.layer.addSublayer(rightShapeLayer)
    }
    
    @objc func leftButtonPressed(_ sender: UIButton) {
        setupCustomButtons(hsbShadeTint(color: colorTheme, sat: 0.40), .gray)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        rightArm = !rightArm
        setupViews()
    }
    
    @objc func rightButtonPressed(_ sender: UIButton) {
        setupCustomButtons(.gray, hsbShadeTint(color: colorTheme, sat: 0.40))
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        rightArm = !rightArm
        setupViews()
    }
}
