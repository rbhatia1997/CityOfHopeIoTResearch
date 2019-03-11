//
//  SimpleProgressGraph.swift
//  PatientApp
//
//  Created by Darien Joso on 3/7/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class SimpleProgressGraph: UIView {
    
    var colorTheme = UIColor()
    var numberOfExercises = Int()
    var exerciseNames = [String]()
    var exerciseValues = [CGFloat]()
    var progressAverage = CGFloat()
    var darkestSaturation = CGFloat()

    private let title = UILabel()
    private let largeGraphView = UIView()
    private var singleSmallGraphView = [UIView]()
    private let stackGraphView = UIStackView()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        colorTheme = .black
        numberOfExercises = 0
        exerciseNames = [""]
        exerciseValues = [0]
        progressAverage = 0
        darkestSaturation = 0.0
    }
    
    init(color: UIColor, exNames: [String], exValues: [CGFloat], darkestSat: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        colorTheme = color
        numberOfExercises = exNames.count
        exerciseNames = exNames
        exerciseValues = exValues
        for i in 0..<numberOfExercises {
            progressAverage += exerciseValues[i]
        }
        progressAverage /= CGFloat(numberOfExercises)
        darkestSaturation = darkestSat
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(_ numOfExercises: Int, _ namesOfExercises: [String], _ valuesOfExercises: [CGFloat], _ outerDia: CGFloat) {
        title.frame = .zero
        title.font = UIFont(name: "Montserrat-Regular", size: 14)
        title.textColor = .gray
        title.text = "Exercise Progress"
        title.sizeToFit()
        title.textAlignment = .center
        
        largeGraphView.frame = .zero
        largeGraphView.backgroundColor = .clear
        drawSemicircleGraph(value: progressAverage,
                            exName: "Overall",
                            outerDia: 200,
                            innerDia: 150,
                            color: hsbShadeTint(color: colorTheme, sat: darkestSaturation),
                            trackSat: colorTheme.hsba.saturation,
                            view: largeGraphView)
        
        stackGraphView.frame = .zero
        stackGraphView.axis = .horizontal
        stackGraphView.distribution = .fillEqually
        for i in 0..<numOfExercises {
            singleSmallGraphView.append(UIView())

            singleSmallGraphView[i].frame = .zero
            singleSmallGraphView[i].backgroundColor = .clear
            drawSemicircleGraph(value: valuesOfExercises[i],
                                exName: namesOfExercises[i],
                                outerDia: outerDia,
                                innerDia: outerDia * 0.75,
                                color: hsbShadeTint(color: colorTheme, sat: darkestSaturation),
                                trackSat: colorTheme.hsba.saturation,
                                view: singleSmallGraphView[i])

            stackGraphView.insertArrangedSubview(singleSmallGraphView[i], at: i)
        }
        
    }
    
    private func addViews() {
        self.addSubview(title)
        self.addSubview(largeGraphView)
        self.addSubview(stackGraphView)
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        title.translatesAutoresizingMaskIntoConstraints = false
        largeGraphView.translatesAutoresizingMaskIntoConstraints = false
        stackGraphView.translatesAutoresizingMaskIntoConstraints = false
        
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: title.frame.width).isActive = true
        title.heightAnchor.constraint(equalToConstant: title.frame.height).isActive = true
        
        largeGraphView.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        largeGraphView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        largeGraphView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        largeGraphView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        stackGraphView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackGraphView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackGraphView.heightAnchor.constraint(equalTo: largeGraphView.heightAnchor, multiplier: 0.5).isActive = true
        stackGraphView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func drawSemicircleGraph(value: CGFloat, exName: String, outerDia: CGFloat, innerDia: CGFloat, color: UIColor, trackSat: CGFloat, view: UIView) {
        
        let valueLabel = UILabel()
        valueLabel.frame = .zero
        valueLabel.font = UIFont(name: "Montserrat-ExtraLight", size: innerDia / 4)
        valueLabel.textColor = .black
        valueLabel.text = " \((value * 1000).rounded()/10)%"
        valueLabel.sizeToFit()
        valueLabel.textAlignment = .center
        
        let exLabel = UILabel()
        exLabel.frame = .zero
        exLabel.font = UIFont(name: "Montserrat-ExtraLight", size: innerDia / 6)
        exLabel.textColor = .black
        exLabel.text = exName
        exLabel.sizeToFit()
        exLabel.textAlignment = .center
        
        view.addSubview(valueLabel)
        view.addSubview(exLabel)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.widthAnchor.constraint(equalToConstant: valueLabel.frame.width).isActive = true
        valueLabel.heightAnchor.constraint(equalToConstant: valueLabel.frame.height).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        exLabel.translatesAutoresizingMaskIntoConstraints = false
        exLabel.widthAnchor.constraint(equalToConstant: exLabel.frame.width).isActive = true
        exLabel.heightAnchor.constraint(equalToConstant: exLabel.frame.height).isActive = true
        exLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        exLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: innerDia/8).isActive = true
        
        singleCircleGraph(center: CGPoint(x: valueLabel.frame.width/2, y: valueLabel.frame.height),
                          endAng: value * 2 * CGFloat.pi,
                          outerDia: outerDia,
                          innerDia: innerDia,
                          color: color,
                          trackSat: trackSat,
                          progSat: color.hsba.saturation,
                          fullCircle: false,
                          view: valueLabel)
    }
    
    private func singleCircleGraph(center: CGPoint, endAng: CGFloat, outerDia: CGFloat, innerDia: CGFloat, color: UIColor, trackSat: CGFloat, progSat: CGFloat, fullCircle: Bool, view: UIView) {
        
        let trackWidth: CGFloat = (outerDia - innerDia)/2
        let trackCenterRadius: CGFloat = (innerDia + trackWidth)/2
        let capShape = CAShapeLayerLineCap.round
        
        let trackPath = UIBezierPath(arcCenter: center,
                                     radius: trackCenterRadius,
                                     startAngle: fullCircle ? -degToRad(deg: 90) : -degToRad(deg: 180),
                                     endAngle: fullCircle ? degToRad(deg: 270): degToRad(deg: 0),
                                     clockwise: true)
        let trackColor = hsbShadeTint(color: color, sat: trackSat)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = trackWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = capShape
        view.layer.addSublayer(trackLayer)
        
        let progPath = UIBezierPath(arcCenter: center,
                                    radius: trackCenterRadius,
                                    startAngle: fullCircle ? -degToRad(deg: 90) : -degToRad(deg: 180),
                                    endAngle: fullCircle ? (endAng - degToRad(deg: 90)) : (endAng/2 - degToRad(deg: 180)),
                                    clockwise: true)
        let progColor = hsbShadeTint(color: color, sat: progSat)
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = progPath.cgPath
        progressLayer.strokeColor = progColor.cgColor
        progressLayer.lineWidth = trackWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = fullCircle ? CAShapeLayerLineCap.round : capShape
        progressLayer.strokeEnd = 0
        view.layer.addSublayer(progressLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        progressLayer.add(basicAnimation, forKey: "oneCircle")
    }
    
    func updateProgressGraph() {
        setupViews(numberOfExercises, exerciseNames, exerciseValues, CGFloat(160 - 20 * numberOfExercises))
        addViews()
        setupConstraints()
    }
}
