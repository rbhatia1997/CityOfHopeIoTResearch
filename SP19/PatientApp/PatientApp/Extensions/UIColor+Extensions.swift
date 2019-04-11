//
//  UIColor+Extensions.swift
//  PatientApp
//
//  Created by Darien Joso on 3/24/19.
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
    
    func hsbSat(_ sat: CGFloat) -> UIColor {
        let hue = hsba.hue
        let brt = hsba.brightness
        let alp = hsba.alpha
        
        return UIColor(hue: hue, saturation: sat, brightness: brt, alpha: alp)
    }
    
    func hsbBrt(_ brt: CGFloat) -> UIColor {
        let hue = hsba.hue
        let sat = hsba.saturation
        let alp = hsba.alpha
        
        return UIColor(hue: hue, saturation: sat, brightness: brt, alpha: alp)
    }
}

func hsbShadeTint(color: UIColor, sat: CGFloat) -> UIColor {
    let hue = color.hsba.hue
    let brt = color.hsba.brightness
    let alp = color.hsba.alpha
    
    return UIColor(hue: hue, saturation: sat, brightness: brt, alpha: alp)
}
