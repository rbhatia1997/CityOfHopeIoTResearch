//
//  Header.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

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

func hsbShadeTint(color: UIColor, sat: CGFloat) -> UIColor {
    let hue = color.hsba.hue
    let brt = color.hsba.brightness
    let alp = color.hsba.alpha
    
    return UIColor(hue: hue, saturation: sat, brightness: brt, alpha: alp)
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

func degToRad(deg: Double) -> CGFloat{
    return CGFloat(deg/180) * CGFloat.pi
}

class Header: UIView {

    let label = UILabel()
    
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = color
        setupViews(title)
        addViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(_ title: String) {
        label.frame = .zero
        label.font = UIFont(name: "MontserratAlternates-ExtraLight", size: 30)
        label.textColor = .black
        label.text = title
        label.sizeToFit()
        label.textAlignment = .center
    }
    
    private func addViews() {
        self.addSubview(label)
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    
}
