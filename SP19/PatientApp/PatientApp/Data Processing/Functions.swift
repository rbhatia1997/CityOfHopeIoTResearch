//
//  Master.swift
//  PatientApp
//
//  Created by Darien Joso on 3/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import Foundation
import UIKit

func findPoint(center: CGPoint, color: UIColor, view: UIView) {
    let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = circlePath.cgPath
    shapeLayer.fillColor = color.cgColor
    shapeLayer.strokeColor = UIColor.clear.cgColor
    shapeLayer.lineWidth = 0.1
    view.layer.addSublayer(shapeLayer)
}

func showBorder(view: UIView) {
    let screen = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    let screenPath = UIBezierPath(rect: screen)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = screenPath.cgPath
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = UIColor.black.cgColor
    shapeLayer.lineWidth = 1.0
    view.layer.addSublayer(shapeLayer)
}

func showBorder(view: UIView, corner: CGFloat, color: UIColor) {
    let screen = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    let screenPath = UIBezierPath(roundedRect: screen, cornerRadius: corner)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = screenPath.cgPath
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = 1.0
    view.layer.addSublayer(shapeLayer)
}

func drawRoundedRect(view: UIView, center: CGPoint, width: CGFloat, height: CGFloat, corner: CGFloat, color: UIColor, strokeWidth: CGFloat) {
    let screen = CGRect(x: center.x - width/2, y: center.y - height/2, width: width, height: height)
    let screenPath = UIBezierPath(roundedRect: screen, cornerRadius: corner)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = screenPath.cgPath
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = strokeWidth
    view.layer.addSublayer(shapeLayer)
}

func drawRoundedRect(view: UIView, origin: CGPoint, width: CGFloat, height: CGFloat, corner: CGFloat, color: UIColor, strokeWidth: CGFloat) {
    let screen = CGRect(x: origin.x, y: origin.y, width: width, height: height)
    let screenPath = UIBezierPath(roundedRect: screen, cornerRadius: corner)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = screenPath.cgPath
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = strokeWidth
    view.layer.addSublayer(shapeLayer)
}

func degToRad(deg: Double) -> CGFloat{
    return CGFloat(deg/180) * CGFloat.pi
}

func srfa(_ lower: Float, _ upper: Float, _ n: Int) -> [Float] {
// sorted random float array
    let intArray = (0...100).randomElements(n).sorted()
    var floatArray = [Float]()
    for int in intArray {
        floatArray.append( (upper - lower) * Float(int)/100 + lower )
    }
    return floatArray
}

func arrayOfsrfa(_ lower: Float, _ upper: Float, _ n: Int, _ e: Int) -> [[Float]] {
// random array of float arrays
    var arrayOfFloatArrays = [[Float]]()
    for _ in 0..<e {
        arrayOfFloatArrays.append(srfa(lower, upper, n))
    }
    return arrayOfFloatArrays
}
