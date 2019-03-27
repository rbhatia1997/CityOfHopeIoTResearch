//
//  SimpleProgressGraph.swift
//  PatientApp
//
//  Created by Darien Joso on 3/7/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class SimpleProgressGraph: UIView {
    
    // public variables
    public var colorTheme: UIColor!
    public var numberOfExercises: Int!
    public var exerciseNames: [String]!
    public var exerciseValues: [CGFloat]!

    // construction variables
    private let title = UILabel()
    private let largeGraphView = UIView()
    private var singleSmallGraphView = [UIView]()
    private let stackGraphView = UIStackView()
    
    // global variables
    private var darkestSaturation: CGFloat = 0.40
    private var progressAverage: CGFloat = 0.0

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        title.setLabelParams(color: .gray, string: "Exercise Progress", ftype: "Montserrat-Regular",
                             fsize: 14, align: .center)
        
        for i in 0..<numberOfExercises {
            progressAverage += exerciseValues[i]
        }
        progressAverage /= CGFloat(numberOfExercises)
        
        largeGraphView.frame = .zero
        largeGraphView.backgroundColor = .clear
//        drawSemicircleGraph(value: progressAverage,
//                            exName: "Overall",
//                            outerDia: 200,
//                            innerDia: 150,
//                            color: colorTheme,
//                            view: largeGraphView)
        
        drawFullCircleGraph(value: progressAverage, exName: "to baseline", outerDia: 250, innerDia: 180, color: colorTheme, view: largeGraphView)
        
//        stackGraphView.frame = .zero
//        stackGraphView.axis = .horizontal
//        stackGraphView.distribution = .fillEqually
//
//        var outerDia: CGFloat = 0
//
//        for i in 0..<numberOfExercises {
//
//            outerDia = CGFloat(160 - 20 * numberOfExercises)
//
//            singleSmallGraphView.append(UIView())
//
//            singleSmallGraphView[i].frame = .zero
//            singleSmallGraphView[i].backgroundColor = .clear
//            drawSemicircleGraph(value: exerciseValues[i],
//                                exName: exerciseNames[i],
//                                outerDia: outerDia,
//                                innerDia: outerDia * 0.75,
//                                color: colorTheme,
//                                view: singleSmallGraphView[i])
//
//            stackGraphView.insertArrangedSubview(singleSmallGraphView[i], at: i)
//        }
        
        self.addSubview(title)
        self.addSubview(largeGraphView)
//        self.addSubview(stackGraphView)
    }
    
    private func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: title.frame.width).isActive = true
        title.heightAnchor.constraint(equalToConstant: title.frame.height).isActive = true
        
        largeGraphView.translatesAutoresizingMaskIntoConstraints = false
        largeGraphView.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        largeGraphView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        largeGraphView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        largeGraphView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
//        stackGraphView.translatesAutoresizingMaskIntoConstraints = false
//        stackGraphView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        stackGraphView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        stackGraphView.heightAnchor.constraint(equalTo: largeGraphView.heightAnchor, multiplier: 0.5).isActive = true
//        stackGraphView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func drawFullCircleGraph(value: CGFloat, exName: String, outerDia: CGFloat, innerDia: CGFloat, color: UIColor, view: UIView) {
        let valueLabel = UILabel()
        valueLabel.setLabelParams(color: .black, string: " \((value * 1000).rounded()/10)%",
            ftype: "Montserrat-ExtraLight", fsize: innerDia / 4, align: .center)
        
        let exLabel = UILabel()
        exLabel.setLabelParams(color: .black, string: exName, ftype: "Montserrat-ExtraLight",
                               fsize: innerDia / 6, align: .center)
        
        view.addSubview(valueLabel)
        view.addSubview(exLabel)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.widthAnchor.constraint(equalToConstant: valueLabel.frame.width).isActive = true
        valueLabel.heightAnchor.constraint(equalToConstant: valueLabel.frame.height).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        
        exLabel.translatesAutoresizingMaskIntoConstraints = false
        exLabel.widthAnchor.constraint(equalToConstant: exLabel.frame.width).isActive = true
        exLabel.heightAnchor.constraint(equalToConstant: exLabel.frame.height).isActive = true
        exLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        exLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor).isActive = true //innerDia/8
        
        singleCircleGraph(center: CGPoint(x: valueLabel.frame.width/2, y: valueLabel.frame.height),
                          endAng: value * CGFloat.pi,
                          outerDia: outerDia,
                          innerDia: innerDia,
                          color: color,
                          fullCircle: true,
                          view: valueLabel)
    }
    
    private func drawSemicircleGraph(value: CGFloat, exName: String, outerDia: CGFloat, innerDia: CGFloat, color: UIColor, view: UIView) {
        
        let valueLabel = UILabel()
        valueLabel.setLabelParams(color: .black, string: " \((value * 1000).rounded()/10)%",
            ftype: "Montserrat-ExtraLight", fsize: innerDia / 4, align: .center)
        
        let exLabel = UILabel()
        exLabel.setLabelParams(color: .black, string: exName, ftype: "Montserrat-ExtraLight",
                               fsize: innerDia / 6, align: .center)
        
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
                          fullCircle: false,
                          view: valueLabel)
    }
    
    private func singleCircleGraph(center: CGPoint, endAng: CGFloat, outerDia: CGFloat, innerDia: CGFloat, color: UIColor, fullCircle: Bool, view: UIView) {
        
        let trackWidth: CGFloat = (outerDia - innerDia)/2
        let trackCenterRadius: CGFloat = (innerDia + trackWidth)/2
        let capShape = CAShapeLayerLineCap.round
        
        let trackPath = UIBezierPath(arcCenter: center,
                                     radius: trackCenterRadius,
                                     startAngle: fullCircle ? -degToRad(deg: 90) : -degToRad(deg: 180),
                                     endAngle: fullCircle ? degToRad(deg: 270): degToRad(deg: 0),
                                     clockwise: true)
        let trackColor = color //color
        
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
                                    endAngle: fullCircle ? (endAng*2 - degToRad(deg: 90)) : (endAng/2 - degToRad(deg: 180)),
                                    clockwise: true)
        let progColor = hsbShadeTint(color: color, sat: darkestSaturation)
        
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
    
    func updateProgressGraph(color: UIColor, exNum: Int, exVal: [CGFloat], exName: [String]) {
        colorTheme = color
        numberOfExercises = exNum
        exerciseValues = exVal
        exerciseNames = exName
        setupViews()
        setupConstraints()
    }
}
