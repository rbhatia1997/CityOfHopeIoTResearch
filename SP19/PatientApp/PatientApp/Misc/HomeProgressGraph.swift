//
//  HomeProgressGraph.swift
//  PatientApp
//
//  Created by Darien Joso on 3/6/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit



class HomeProgressGraph: UIView {
    
    private var colorTheme = UIColor()
    var exerciseNames = [String]()
    var exerciseValues = [CGFloat]()
    private var progressAverage = CGFloat()
    private var darkestSaturation = CGFloat()
    
    private var numberOfExercises = Int()
    
    let singleGraphView = UIView()
    let multipleGraphView = UIView()

    private let singleButton = UIButton()
    private let multipleButton = UIButton()
    
    private var progLayer = [CAShapeLayer]()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .gray
    }
    
    init(color: UIColor, exNames: [String], exValues: [CGFloat], outerRad: CGFloat, innerRad: CGFloat, darkestSat: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        colorTheme = color
        numberOfExercises = exNames.count
        exerciseNames = exNames
        exerciseValues = exValues
        darkestSaturation = darkestSat
        
        for value in exerciseValues {
            progressAverage += value
        }
        progressAverage /= CGFloat(numberOfExercises)
        
        setupViews()
        addViews()
        setupConstraints()
        setupInteract()

//        findPoint(center: singleGraphView.center, color: .black, view: singleGraphView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        singleButton.frame = .zero
        singleButton.setTitle("Overall Progress", for: .normal)
        singleButton.setTitleColor(.gray, for: .normal)
        singleButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14.0)
        singleButton.sizeToFit()
        singleButton.titleLabel?.textAlignment = .center
        
        multipleButton.frame = .zero
        multipleButton.setTitle("Exercise Progress", for: .normal)
        multipleButton.setTitleColor(.gray, for: .normal)
        multipleButton.titleLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 14) ?? UIFont.systemFont(ofSize: 14.0)
        multipleButton.sizeToFit()
        multipleButton.titleLabel?.textAlignment = .center
        
        singleGraphView.frame = .zero
        singleGraphView.backgroundColor = .clear
        singleGraphView.tag = 100
        
        multipleGraphView.frame = .zero
        multipleGraphView.backgroundColor = .clear
        multipleGraphView.tag = 101
    }
    
    private func addViews() {
        self.addSubview(singleButton)
        self.addSubview(multipleButton)
        addSingle()
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        singleButton.translatesAutoresizingMaskIntoConstraints = false
        singleButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        singleButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -70).isActive = true
        
        multipleButton.translatesAutoresizingMaskIntoConstraints = false
        multipleButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        multipleButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 70).isActive = true
    }
    
    func addExercise(exName: String, exValue: CGFloat) {
        exerciseNames.append(exName)
        exerciseValues.append(exValue)
        numberOfExercises += 1
    }
    
    private func setupInteract() {
        singleButton.addTarget(self, action: #selector(resetSingleGraph), for: .touchUpInside)
        multipleButton.addTarget(self, action: #selector(resetmultipleGraph), for: .touchUpInside)
    }
    
    @objc func resetSingleGraph() {
        removeGraphViews()
        addSingle()
        
        singleButton.setTitleColor(.gray, for: .normal)
        singleButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        singleButton.sizeToFit()
        
        multipleButton.setTitleColor(.lightGray, for: .normal)
        multipleButton.titleLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 14)
        multipleButton.sizeToFit()
    }
    
    @objc func resetmultipleGraph() {
        removeGraphViews()
        addMultiple()
        
        singleButton.setTitleColor(.lightGray, for: .normal)
        singleButton.titleLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 14)
        singleButton.sizeToFit()
        
        multipleButton.setTitleColor(.gray, for: .normal)
        multipleButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        multipleButton.sizeToFit()
    }
    
    private func singleCircleGraph(center: CGPoint, endAng: CGFloat, outerDia: CGFloat, innerDia: CGFloat, color: UIColor, trackSat: CGFloat, progSat: CGFloat, fullCircle: Bool, view: UIView) {
        
        let trackWidth: CGFloat = (outerDia - innerDia)/2
        let trackCenterRadius: CGFloat = (innerDia + trackWidth)/2
        
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
        progressLayer.lineCap = fullCircle ? CAShapeLayerLineCap.butt : CAShapeLayerLineCap.butt
        progressLayer.strokeEnd = 0
        view.layer.addSublayer(progressLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        progressLayer.add(basicAnimation, forKey: "oneCircle")
    }
    
    private func drawSingleGraph(center: CGPoint, value: CGFloat, outerDia: CGFloat, color: UIColor, innerDia: CGFloat, trackSat: CGFloat) {
        singleCircleGraph(center: center,
                          endAng: value * 2 * CGFloat.pi,
                          outerDia: outerDia,
                          innerDia: innerDia,
                          color: color,
                          trackSat: trackSat,
                          progSat: color.hsba.saturation,
                          fullCircle: true,
                          view: singleGraphView)
        
        let valueLabel = UILabel()
        valueLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        valueLabel.font = UIFont(name: "Montserrat-ExtraLight", size: innerDia / 4)
        valueLabel.textColor = .black
        valueLabel.text = " \((value * 1000).rounded()/10)%"
        valueLabel.sizeToFit()
        valueLabel.textAlignment = .center
        valueLabel.center = center
        
        singleGraphView.addSubview(valueLabel)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXAnchor.constraint(equalTo: singleGraphView.centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: singleGraphView.centerYAnchor).isActive = true
    }
    
    private func addSingle() {
        drawSingleGraph(center: CGPoint(x: singleGraphView.frame.width/2, y: singleGraphView.frame.height/2),
                        value: progressAverage,
                        outerDia: 200,
                        color: hsbShadeTint(color: colorTheme, sat: darkestSaturation),
                        innerDia: 150,
                        trackSat: colorTheme.hsba.saturation)
        
        self.addSubview(singleGraphView)
        
        singleGraphView.translatesAutoresizingMaskIntoConstraints = false
        singleGraphView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        singleGraphView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: singleButton.frame.height/2).isActive = true
    }
    
    private func drawMultipleGraph(center: CGPoint, value: CGFloat, exName: String, outerDia: CGFloat, color: UIColor, innerDia: CGFloat, trackSat: CGFloat) {
        let adjustCenter = CGPoint(x: center.x, y: center.y*3/2)
        singleCircleGraph(center: adjustCenter,
                          endAng: value * 2 * CGFloat.pi,
                          outerDia: outerDia,
                          innerDia: innerDia,
                          color: color,
                          trackSat: trackSat,
                          progSat: color.hsba.saturation,
                          fullCircle: false,
                          view: multipleGraphView)
        
        let valueLabel = UILabel()
        valueLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        valueLabel.font = UIFont(name: "Montserrat-ExtraLight", size: innerDia / 4)
        valueLabel.textColor = .black
        valueLabel.text = " \((value * 1000).rounded()/10)%"
        valueLabel.sizeToFit()
        valueLabel.textAlignment = .center
        valueLabel.center = center
        
        let exLabel = UILabel()
        exLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        exLabel.font = UIFont(name: "Montserrat-ExtraLight", size: innerDia / 6)
        exLabel.textColor = .black
        exLabel.text = exName
        exLabel.sizeToFit()
        exLabel.textAlignment = .center
        exLabel.center = center
        
        multipleGraphView.addSubview(valueLabel)
        multipleGraphView.addSubview(exLabel)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXAnchor.constraint(equalTo: multipleGraphView.centerXAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: multipleGraphView.centerYAnchor).isActive = true
        
        exLabel.translatesAutoresizingMaskIntoConstraints = false
        exLabel.centerXAnchor.constraint(equalTo: multipleGraphView.centerXAnchor).isActive = true
        exLabel.topAnchor.constraint(equalTo: multipleGraphView.centerYAnchor, constant: innerDia/15).isActive = true
    }
    
    private func addMultiple() {
        drawMultipleGraph(center: CGPoint(x: multipleGraphView.frame.width/2, y: multipleGraphView.frame.height/2),
                          value: progressAverage,
                          exName: "Front Arm Raise",
                          outerDia: 100,
                          color: hsbShadeTint(color: colorTheme, sat: darkestSaturation),
                          innerDia: 80,
                          trackSat: colorTheme.hsba.saturation)
        
        self.addSubview(multipleGraphView)
        
        multipleGraphView.translatesAutoresizingMaskIntoConstraints = false
        multipleGraphView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        multipleGraphView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: singleButton.frame.height/2).isActive = true
    }
    
    private func removeGraphViews() {
        if let viewWithTag = self.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        } else if let viewWithTag = self.viewWithTag(101) {
            viewWithTag.removeFromSuperview()
        } else {
            print("Nothing to remove!")
        }
    }
}


