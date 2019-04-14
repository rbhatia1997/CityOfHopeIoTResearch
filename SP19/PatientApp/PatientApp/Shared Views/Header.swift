//
//  Header.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class Header: UIView {
    
    // public variables
    public var headerString: String!
    public var headerColor: UIColor!
    public var fontSize: CGFloat!
    
    // construction variables
    private let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .gray
    }
    
    init(_ title: String, _ color: UIColor, _ size: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = .gray
        
        headerString = title
        headerColor = color
        fontSize = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = headerColor
        label.frame = .zero
        label.font = UIFont(name: "MontserratAlternates-ExtraLight", size: fontSize)
        label.textColor = .black
        label.text = headerString
//        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        self.addSubview(label)
    }
    
    private func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    func updateHeader(text: String, color: UIColor, fsize: CGFloat) {
        headerString = text
        headerColor = color
        fontSize = fsize
        setupViews()
        setupConstraints()
    }
}
