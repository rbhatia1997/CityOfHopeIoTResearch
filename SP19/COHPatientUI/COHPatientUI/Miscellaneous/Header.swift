//
//  Header.swift
//  COHPatientUI
//
//  Created by Darien Joso on 2/28/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class Header: UIView {
    
//    override func draw(_ rect: CGRect) {}
    
    func setHeader(text: String, color: UIColor) {
        self.backgroundColor = color
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        headerLabel.font = UIFont(name: "MontserratAlternates-ExtraLight", size: 30)
        headerLabel.textColor = .black
        headerLabel.text = text
        headerLabel.sizeToFit()
        headerLabel.textAlignment = .center
        headerLabel.center.x = self.frame.width/2
        headerLabel.center.y = self.frame.height/2
        
//        headerLabel.layer.borderColor = UIColor.black.cgColor;
//        headerLabel.layer.borderWidth = 1.0;
        
        self.addSubview(headerLabel)
    }
}
