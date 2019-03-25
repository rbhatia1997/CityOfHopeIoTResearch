//
//  Master.swift
//  PatientApp
//
//  Created by Darien Joso on 3/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

struct Quaternion {
    func quatMultiply(_ quat1: [Float], _ quat2: [Float]) -> [Float] {
        // input: 2 quaternions (4 float array)
        // output: 1 quaternion (4 float array)
        var retQuat: [Float] = [0, 0, 0, 0]
        
        if (quat1.count != 4 || quat2.count != 4) {
            print("incorrect quaternion sizes")
            return retQuat
        }
        
        retQuat[0] = quat1[0]*quat2[0] - quat1[1]*quat2[1] - quat1[2]*quat2[2] - quat1[3]*quat2[3]
        retQuat[1] = quat1[0]*quat2[1] + quat1[1]*quat2[0] + quat1[2]*quat2[3] - quat1[3]*quat2[2]
        retQuat[2] = quat1[0]*quat2[2] - quat1[1]*quat2[3] + quat1[2]*quat2[0] + quat1[3]*quat2[1]
        retQuat[3] = quat1[0]*quat2[3] + quat1[1]*quat2[2] - quat1[2]*quat2[1] + quat1[3]*quat2[0]
        
        return retQuat
    }
    
    func quatInverse(_ quat: [CGFloat]) -> [CGFloat] {
        // input: 1 quaternion (4 CGFloat array)
        // output: 1 quaternion (4 CGFloat array)
        var retQuat: [CGFloat] = [0, 0, 0, 0]
        
        if (quat.count != 4) {
            print("incorrect quaternion size")
            return retQuat
        }
        
        retQuat = [quat[0], -quat[1], -quat[2], -quat[3]]
        
        return retQuat
    }
    
    func computeAngles (_ quat: [CGFloat]) -> [CGFloat] {
        // input: quaternion (4 CGFloat array)
        // output: roll/pitch/yaw array of (3 CGFloat array)
        let roll = atan( (quat[0]*quat[1] + quat[2]*quat[3]) / (0.5 - quat[1]*quat[1] - quat[2]*quat[2]) )
        let pitch = asin(-2.0*(quat[1]*quat[3] - quat[0]*quat[2]))
        let yaw = atan( (quat[1]*quat[2] + quat[0]*quat[3]) / (0.5 - quat[2]*quat[2] - quat[3]*quat[3]) )
        
        let rpy = [roll, pitch, yaw]
        
        return rpy
    }
}

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

func degToRad(deg: Double) -> CGFloat{
    return CGFloat(deg/180) * CGFloat.pi
}

