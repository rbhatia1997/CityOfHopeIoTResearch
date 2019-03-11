//
//  CircleGraph.swift
//  PatientApp
//
//  Created by Darien Joso on 3/7/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class CircleGraph: UIView {

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .gray
    }
    
    init(color: UIColor, exName: String, exValue: CGFloat, outerDia: CGFloat, innerDia: CGFloat, trackSat: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = .yellow
        
//        drawSemicircleGraph(center: self.center, value: exValue, exName: exName, outerDia: outerDia, innerDia: innerDia, color: color, trackSat: trackSat)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawSemicircleGraph(center: CGPoint, value: CGFloat, exName: String, outerDia: CGFloat, innerDia: CGFloat, color: UIColor, trackSat: CGFloat) {
        singleCircleGraph(center: center,
                          endAng: value * 2 * CGFloat.pi,
                          outerDia: outerDia,
                          innerDia: innerDia,
                          color: color,
                          trackSat: trackSat,
                          progSat: color.hsba.saturation,
                          fullCircle: false)
        
        let valueLabel = UILabel()
        valueLabel.frame = .zero
        valueLabel.font = UIFont(name: "Montserrat-ExtraLight", size: innerDia / 4)
        valueLabel.textColor = .black
        valueLabel.text = " \((value * 1000).rounded()/10)%"
        valueLabel.sizeToFit()
        valueLabel.textAlignment = .center
        valueLabel.center = center
        
        let exLabel = UILabel()
        exLabel.frame = .zero
        exLabel.font = UIFont(name: "Montserrat-ExtraLight", size: innerDia / 6)
        exLabel.textColor = .black
        exLabel.text = exName
        exLabel.sizeToFit()
        exLabel.textAlignment = .center
        exLabel.center = center
        
        self.addSubview(valueLabel)
        self.addSubview(exLabel)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        exLabel.translatesAutoresizingMaskIntoConstraints = false
        exLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        exLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: innerDia/15).isActive = true
    }
    
    private func singleCircleGraph(center: CGPoint, endAng: CGFloat, outerDia: CGFloat, innerDia: CGFloat, color: UIColor, trackSat: CGFloat, progSat: CGFloat, fullCircle: Bool) {

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
        self.layer.addSublayer(trackLayer)
        
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
        self.layer.addSublayer(progressLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        progressLayer.add(basicAnimation, forKey: "oneCircle")
    }
}
