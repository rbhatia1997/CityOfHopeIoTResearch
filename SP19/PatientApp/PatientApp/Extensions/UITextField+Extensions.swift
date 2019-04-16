//
//  UITextField+Extensions.swift
//  PatientApp
//
//  Created by Darien Joso on 4/14/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

extension UITextField {
    func setTextFieldParams(color: UIColor, bgColor: UIColor, string: String, ftype: String, fsize: CGFloat, align: NSTextAlignment) {
        frame = .zero
        backgroundColor = bgColor
        textColor = color
        text = string
        font = UIFont(name: ftype, size: fsize)!
        textAlignment = align
    }
}
