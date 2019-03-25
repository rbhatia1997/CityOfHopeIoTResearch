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
}
