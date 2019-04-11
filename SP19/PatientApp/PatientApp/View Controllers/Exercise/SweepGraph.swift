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
    var leftArm: Bool!
    var currPos: CGFloat! // in radians
    var repCount: Int = 0
    
    // construction variables
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let valueLabel = UILabel()
    private let lineCap = CAShapeLayerLineCap.butt
    
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
        leftArm = dir
        currPos = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSweepGraph(color: UIColor, start: CGFloat, max: CGFloat, left: Bool, value: CGFloat) {
        colorTheme = color
        startAngle = start
        maxAngle = max
        leftArm = left
        currPos = value
        
        if let viewWithTag = self.viewWithTag(103) {
            viewWithTag.removeFromSuperview()
        }
        
        setupViews()
        setupConstraints()
    }
    
    func setSweepGraphValue(value: CGFloat) {
        currPos = value
        
        if let viewWithTag = self.viewWithTag(103) {
            viewWithTag.removeFromSuperview()
        }
        
        if leftArm {
            setupCustomButtons(hsbShadeTint(color: colorTheme, sat: 0.40), .gray)
        } else {
            setupCustomButtons(.gray, hsbShadeTint(color: colorTheme, sat: 0.40))
        }
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        
        let outerDia: CGFloat = 200
        let innerDia: CGFloat = outerDia * 0.75
        
        if let layerArray = valueLabel.layer.sublayers {
            for layer in layerArray {
                if layer.name == "tick" || layer.name == "progress" {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        valueLabel.setLabelParams(color: .black, string: repCount == 1 ? "\(repCount) rep " : "\(repCount) reps ", ftype: "Montserrat-ExtraLight", fsize: innerDia/4, align: .center, tag: 103)
        self.addSubview(valueLabel)
        
        drawActiveLayer(center: CGPoint(x: valueLabel.frame.width/2, y: valueLabel.frame.height/2),
                        color: colorTheme,
                        start: startAngle,
                        value: currPos,
                        max: maxAngle,
                        leftArm: leftArm,
                        outerDia: outerDia,
                        innerDia: innerDia,
                        view: valueLabel)
        
        drawTicks(center: CGPoint(x: valueLabel.frame.width/2, y: valueLabel.frame.height/2), color: colorTheme,
                  leftArm: leftArm, outerDia: outerDia, innerDia: innerDia, view: valueLabel)
        
        setupConstraints()
    }
}

// MARK: drawing the graph
extension SweepGraph {
    private func drawBackgroundLayer(center: CGPoint, color: UIColor, start: CGFloat, value: CGFloat, max: CGFloat, leftArm: Bool, outerDia: CGFloat, innerDia: CGFloat, view: UIView) {
        
        let trackWidth: CGFloat = (outerDia - innerDia)/2
        let trackCenterRadius: CGFloat = (innerDia + trackWidth)/2
        
        let grayPath = UIBezierPath(arcCenter: center,
                                    radius: trackCenterRadius,
                                    startAngle: 0, // in radians
            endAngle: 2*CGFloat.pi, // in radians
            clockwise: leftArm)
        
        let grayLayer = CAShapeLayer()
        grayLayer.path = grayPath.cgPath
        grayLayer.strokeColor = UIColor(white: 250/255, alpha: 1).cgColor
        grayLayer.lineWidth = trackWidth
        grayLayer.fillColor = UIColor.clear.cgColor
        grayLayer.lineCap = lineCap
        view.layer.addSublayer(grayLayer)
        
        let trackPath = UIBezierPath(arcCenter: center,
                                     radius: trackCenterRadius,
                                     startAngle: leftArm ? CGFloat.pi/2 + start : CGFloat.pi/2 - start, // in radians
            endAngle: leftArm ? CGFloat.pi/2 + max : CGFloat.pi/2 - max, // in radians
            clockwise: leftArm)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = color.cgColor
        trackLayer.lineWidth = trackWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = lineCap
        trackLayer.name = "track"
        view.layer.addSublayer(trackLayer)
    }
    
    private func drawTicks(center: CGPoint, color: UIColor, leftArm: Bool, outerDia: CGFloat, innerDia: CGFloat, view: UIView) {
        let tickPath = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var angle: CGFloat = 0
        
        
        let tickCount: Int = 150/10
        
        for i in 0...tickCount {
            angle = degToRad(deg: 90 - Double(10*i))
            x = (leftArm ? -1 : 1) * (0.5*outerDia)*cos(angle)
            y = (0.5*outerDia)*sin(angle)
            tickPath.move(to: CGPoint(x: center.x + x, y: center.y + y))
            
            x *= i % 3 == 0 ? (0.5*innerDia) / (0.5*outerDia) : (0.5*outerDia - 5) / (0.5*outerDia)
            y *= i % 3 == 0 ? (0.5*innerDia) / (0.5*outerDia) : (0.5*outerDia - 5) / (0.5*outerDia)
            tickPath.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
        }
        
        let tickLayer = CAShapeLayer()
        tickLayer.path = tickPath.cgPath
        tickLayer.strokeColor = UIColor(white: 0, alpha: 0.20).cgColor
        tickLayer.lineWidth = 2.0
        tickLayer.fillColor = UIColor.clear.cgColor
        tickLayer.lineCap = CAShapeLayerLineCap.butt
        tickLayer.name = "tick"
        view.layer.addSublayer(tickLayer)
    }

    private func drawActiveLayer(center: CGPoint, color: UIColor, start: CGFloat, value: CGFloat, max: CGFloat, leftArm: Bool, outerDia: CGFloat, innerDia: CGFloat, view: UIView) {
        let trackWidth: CGFloat = (outerDia - innerDia)/2
        let trackCenterRadius: CGFloat = (innerDia + trackWidth)/2
        
        let progPath = UIBezierPath(arcCenter: center,
                                    radius: trackCenterRadius,
                                    startAngle: leftArm ? CGFloat.pi/2 + start : CGFloat.pi/2 - start, // in radians
            endAngle: leftArm ? CGFloat.pi/2 + value : CGFloat.pi/2 - value, // in radians
            clockwise: leftArm)
        
        let progColor = hsbShadeTint(color: color, sat: 0.40)
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = progPath.cgPath
        progressLayer.strokeColor = progColor.cgColor
        progressLayer.lineWidth = trackWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = lineCap
        progressLayer.name = "progress"
        view.layer.addSublayer(progressLayer)
    }
}

// MARK: button actions
extension SweepGraph {
    @objc func leftButtonPressed(_ sender: UIButton) {
        setupCustomButtons(hsbShadeTint(color: colorTheme, sat: 0.40), .gray)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        if (leftArm == false) {
            leftArm = true
        }
        
        if let layerArray = valueLabel.layer.sublayers {
            for layer in layerArray {
                if layer.name == "tick" || layer.name == "track" {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        if let viewWithTag = self.viewWithTag(103) {
            viewWithTag.removeFromSuperview()
        }
        setupViews()
        setupConstraints()
    }
    
    @objc func rightButtonPressed(_ sender: UIButton) {
        setupCustomButtons(.gray, hsbShadeTint(color: colorTheme, sat: 0.40))
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        if (leftArm == true) {
            leftArm = false
        }
        
        if let layerArray = valueLabel.layer.sublayers {
            for layer in layerArray {
                if layer.name == "tick" || layer.name == "track" {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        if let viewWithTag = self.viewWithTag(103) {
            viewWithTag.removeFromSuperview()
        }
        setupViews()
        setupConstraints()
    }
}

extension SweepGraph: ViewConstraintProtocol {
    internal func setupViews() {
        if leftArm {
            setupCustomButtons(hsbShadeTint(color: colorTheme, sat: 0.40), .gray)
        } else {
            setupCustomButtons(.gray, hsbShadeTint(color: colorTheme, sat: 0.40))
        }
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        
        let outerDia: CGFloat = 200
        let innerDia: CGFloat = outerDia * 0.75
        
        valueLabel.setLabelParams(color: .black, string: repCount == 1 ? "\(repCount) rep " : "\(repCount) reps ", ftype: "Montserrat-ExtraLight", fsize: innerDia/4, align: .center, tag: 103)
        self.addSubview(valueLabel)
        
        drawBackgroundLayer(center: CGPoint(x: valueLabel.frame.width/2, y: valueLabel.frame.height/2),
                       color: colorTheme,
                       start: startAngle,
                       value: currPos,
                       max: maxAngle,
                       leftArm: leftArm,
                       outerDia: outerDia,
                       innerDia: innerDia,
                       view: valueLabel)
        
        drawActiveLayer(center: CGPoint(x: valueLabel.frame.width/2, y: valueLabel.frame.height/2),
                        color: colorTheme,
                        start: startAngle,
                        value: currPos,
                        max: maxAngle,
                        leftArm: leftArm,
                        outerDia: outerDia,
                        innerDia: innerDia,
                        view: valueLabel)
        
        drawTicks(center: CGPoint(x: valueLabel.frame.width/2, y: valueLabel.frame.height/2), color: colorTheme,
                  leftArm: leftArm, outerDia: outerDia, innerDia: innerDia, view: valueLabel)
    }
    
    internal func setupConstraints() {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        leftButton.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor).isActive = true
        rightButton.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor, constant: -130).isActive = true
    }
    
    private func setupCustomButtons(_ leftColor: UIColor, _ rightColor: UIColor) {
        leftButton.setButtonParams(color: leftColor, string: "Left-arm\nexercise", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        leftButton.titleLabel?.numberOfLines = 2
        leftButton.titleLabel?.textAlignment = .center
        leftButton.setButtonFrame(width: 100, borderWidth: 1.0, borderColor: leftColor, cornerRadius: 5, fillColor: .clear)
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        
        rightButton.setButtonParams(color: rightColor, string: "Right-arm\nexercise", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        rightButton.titleLabel?.numberOfLines = 2
        rightButton.titleLabel?.textAlignment = .center
        rightButton.setButtonFrame(width: 100, borderWidth: 1.0, borderColor: rightColor, cornerRadius: 5, fillColor: .clear)
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
    }
}
