//
//  NestedCircleGraph.swift
//  COHPatientUI
//
//  Created by Darien Joso on 2/26/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class NestedCircleGraph: UIView {
    
    var progLayer = [CAShapeLayer]()
    
//    override func draw(_ rect: CGRect) {}
    
    func drawGraph(exerciseNum: Int, exerciseNames: [String], values: [CGFloat], clr: UIColor, rMax: Double, rMin: Double, trackSat: [CGFloat], progSat: [CGFloat], sweepAngle: CGFloat) {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        let centerX = self.frame.size.width/2 - 60
        let centerY = self.frame.size.height/2
        
        let maxRad: Double = rMax
        let minRad: Double = rMin
        let trackClr: Double = 1
        let l = (maxRad - minRad - (Double(exerciseNum) - 1) * trackClr) / Double(exerciseNum)
        
        var constDistAngle: CGFloat
        
        for index in 0..<exerciseNum {

            let r = maxRad - l/2 - Double(index) * (l + trackClr)

            
            singleCircleGraph(centerX: centerX,
                              centerY: centerY,
                              startAng: degToRad(deg: 0),
                              endAng: values[index] * 2*CGFloat.pi,
                              rad: CGFloat(r),
                              lineWidth: CGFloat(l),
                              depth: index,
                              color: clr,
                              trackSatStart: trackSat[0]/100,
                              trackSatEnd: trackSat[1]/100,
                              progSatStart: progSat[0]/100,
                              progSatEnd: progSat[1]/100,
                              exerciseNum: exerciseNum)
            
            progLayer[index].add(basicAnimation, forKey: "0")
            
            
            constDistAngle = CGFloat(asin( ( 2.0*Double(index) - Double(exerciseNum - 1)) * Double( sin(sweepAngle)) / Double(exerciseNum - 1) ))
//            print(constDistAngle * 180 / CGFloat.pi)
            
            drawCircleLabel(centerX: centerX, centerY: centerY, exerciseName: exerciseNames[index], exerciseValue: values[index] * 100, radius: CGFloat(maxRad - l/2) - CGFloat(index) * CGFloat(l + trackClr), outerRad: CGFloat(rMax) + 10, angle: constDistAngle)
        }
    }
    
    private func singleCircleGraph(centerX: CGFloat, centerY: CGFloat, startAng: CGFloat, endAng: CGFloat, rad: CGFloat, lineWidth: CGFloat, depth: Int, color: UIColor, trackSatStart: CGFloat, trackSatEnd: CGFloat, progSatStart: CGFloat, progSatEnd: CGFloat, exerciseNum: Int) {
        // define center of the circle
        let center = CGPoint(x: centerX, y: centerY)
        
        let trackLayer = CAShapeLayer()
        
        let trackPath = UIBezierPath(arcCenter: center, radius: rad, startAngle: startAng - degToRad(deg: 90), endAngle: degToRad(deg: 270), clockwise: true)
        
        let trackSaturation = trackSatStart - (trackSatStart - trackSatEnd) * CGFloat(depth) / CGFloat(exerciseNum - 1)
        let trackColor = hsbShadeTint(color: color, sat: trackSaturation)

        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(trackLayer)
        
        let progPath = UIBezierPath(arcCenter: center, radius: rad, startAngle: startAng - degToRad(deg: 90), endAngle: endAng - degToRad(deg: 90), clockwise: true)
        
        progLayer.append(CAShapeLayer())
        
        let progSaturation = progSatStart - (progSatStart - progSatEnd) * CGFloat(depth) / CGFloat(exerciseNum - 1)
        let progColor = hsbShadeTint(color: color, sat: progSaturation)
        
        progLayer[depth].path = progPath.cgPath
        progLayer[depth].strokeColor = progColor.cgColor
        progLayer[depth].lineWidth = lineWidth
        progLayer[depth].fillColor = UIColor.clear.cgColor
        progLayer[depth].lineCap = CAShapeLayerLineCap.round
        progLayer[depth].strokeEnd = 0
        self.layer.addSublayer(progLayer[depth])
    }
    
    private func drawCircleLabel(centerX: CGFloat, centerY: CGFloat, exerciseName: String, exerciseValue: CGFloat, radius: CGFloat, outerRad: CGFloat, angle: CGFloat) {
        
        let stem: CGFloat = outerRad - radius
        let base: CGFloat = 12
        
        var start = CGPoint.init()
        start.x = centerX + radius * cos(angle)
        start.y = centerY + radius * sin(angle)
        
        var kink = CGPoint.init()
        kink.x = start.x + stem * cos(angle)
        kink.y = start.y + stem * sin(angle)
        
        var end = CGPoint.init()
        end.x = kink.x + base
        end.y = kink.y
        
        // path of the lines that extend out
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: kink)
        path.addLine(to: end)
        
        let coverLayer = CAShapeLayer()
        coverLayer.path = path.cgPath
        coverLayer.fillColor = UIColor.clear.cgColor
        coverLayer.strokeColor = UIColor.white.cgColor
        coverLayer.lineWidth = 1.0
        coverLayer.lineCap = .round
        coverLayer.strokeEnd = 0
        self.layer.addSublayer(coverLayer)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.lineCap = .round
        self.layer.addSublayer(shapeLayer)
        
        let lineAnimation = CABasicAnimation(keyPath: "strokeEnd")
        lineAnimation.fromValue = 0
        lineAnimation.toValue = 1
        lineAnimation.duration = 0.5
        lineAnimation.fillMode = .forwards
        lineAnimation.isRemovedOnCompletion = false
        shapeLayer.add(lineAnimation, forKey: "1")
        
        let exerciseLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        exerciseLabel.font = UIFont(name: "Montserrat-Light", size: 12)
        exerciseLabel.textColor = .black
        exerciseLabel.text = "\(exerciseName): \(exerciseValue.rounded())%"
        exerciseLabel.sizeToFit()
        exerciseLabel.textAlignment = .center
        exerciseLabel.center.x = end.x + exerciseLabel.frame.width/2 + 5
        exerciseLabel.center.y = end.y //- exerciseLabel.frame.height/2
        self.addSubview(exerciseLabel)
        
//        let percentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        percentLabel.font = UIFont(name: "Montserrat-Light", size: 14)
//        percentLabel.textColor = .black
//        percentLabel.text = "\(exerciseValue.rounded())%"
//        percentLabel.sizeToFit()
//        percentLabel.textAlignment = .center
//        percentLabel.center.x = end.x + exerciseLabel.frame.width/2 + 5
//        percentLabel.center.y = end.y + exerciseLabel.frame.height/2
//        self.addSubview(percentLabel)
        
        
    }
    
    private func degToRad(deg: Double) -> CGFloat{
        return CGFloat(deg/180) * CGFloat.pi
    }
    
    func hsbShadeTint(color: UIColor, sat: CGFloat) -> UIColor {
        let hue = color.hsba.hue
        let brt = color.hsba.brightness
        let alp = color.hsba.alpha
        
        return UIColor(hue: hue, saturation: sat, brightness: brt, alpha: alp)
    }
    
    func wipe() {
        let screen = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let screenPath = UIBezierPath(rect: screen)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = screenPath.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return (r, g, b, a)
    }
    
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        let withinRange = getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        if withinRange {
            return (h, s, b, a)
        } else {
            return (0, 0, 0, 0)
        }
    }
}
