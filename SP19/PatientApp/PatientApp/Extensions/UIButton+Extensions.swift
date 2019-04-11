//
//  UIButton+Extensions.swift
//  PatientApp
//
//  Created by Darien Joso on 3/24/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

extension UIButton {
    func setButtonParams(color: UIColor, string: String, ftype: String, fsize: CGFloat, align: UIControl.ContentHorizontalAlignment) {
        frame = .zero
        setTitleColor(color, for: .normal)
        setTitle(string, for: .normal)
        titleLabel?.font = UIFont(name: ftype, size: fsize)!
        contentHorizontalAlignment = align
        sizeToFit()
    }
    
    func setButtonFrame(borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat, fillColor: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        backgroundColor = fillColor
    }
    
    func setButtonFrame(size: CGSize, borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat, fillColor: UIColor) {
        let screen = CGRect(x: (frame.width - size.width)/2, y: (frame.height - size.height)/2, width: size.width, height: size.height)
        let screenPath = UIBezierPath(roundedRect: screen, cornerRadius: cornerRadius)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = screenPath.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.lineWidth = borderWidth
        layer.addSublayer(shapeLayer)
    }
    
    func setButtonFrame(width: CGFloat, borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat, fillColor: UIColor) {
        setButtonFrame(size: CGSize(width: width, height: frame.height), borderWidth: borderWidth, borderColor: borderColor, cornerRadius: cornerRadius, fillColor: fillColor)
    }
    
    func setButtonFrame(height: CGFloat, borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat, fillColor: UIColor) {
        setButtonFrame(size: CGSize(width: frame.width, height: height), borderWidth: borderWidth, borderColor: borderColor, cornerRadius: cornerRadius, fillColor: fillColor)
    }
}
