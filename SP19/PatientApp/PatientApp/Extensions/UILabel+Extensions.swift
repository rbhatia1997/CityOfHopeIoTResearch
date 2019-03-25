//
//  UILabel+Extensions.swift
//  PatientApp
//
//  Created by Darien Joso on 3/24/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

extension UILabel {
    func setLabelParams(color: UIColor, string: String, ftype: String, fsize: CGFloat, align: NSTextAlignment) {
        frame = .zero
        backgroundColor = .clear
        textColor = color
        text = string
        font = UIFont(name: ftype, size: fsize)!
        numberOfLines = 0
        textAlignment = align
        sizeToFit()
    }
    
    func setLabelParams(color: UIColor, string: String, ftype: String, fsize: CGFloat, align: NSTextAlignment, tag: Int) {
        frame = .zero
        backgroundColor = .clear
        textColor = color
        text = string
        font = UIFont(name: ftype, size: fsize)!
        numberOfLines = 0
        textAlignment = align
        self.tag = tag
        sizeToFit()
    }
}
