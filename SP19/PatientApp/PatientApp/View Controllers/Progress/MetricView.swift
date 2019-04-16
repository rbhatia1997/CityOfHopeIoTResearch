//
//  CompareMetricView.swift
//  PatientApp
//
//  Created by Darien Joso on 4/14/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class MetricView: UIView {
    
    var topText: String!
    var metric: String!
    var bottomText: String!
    
    private let topLabel = UILabel()
    private let bigLabel = UILabel()
    private let bottomLabel = UILabel()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(top: String, metric: String, bottom: String) {
        self.topText = top
        self.metric = metric
        self.bottomText = bottom
        setupViews()
        setupConstraints()
    }
    
}

extension MetricView: ViewConstraintProtocol {
    func setupViews() {
        topLabel.setLabelParams(color: .gray, string: "\(topText!)", ftype: defFont, fsize: 14, align: .center)
        topLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(topLabel)
        
        bigLabel.setLabelParams(color: .gray, string: "\(metric!)", ftype: defFont, fsize: 60, align: .center)
        bigLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(bigLabel)
        
        bottomLabel.setLabelParams(color: .gray, string: "\(bottomText!)", ftype: defFont, fsize: 14, align: .center)
        bottomLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(bottomLabel)
    }
    
    func setupConstraints() {
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
        
        bigLabel.translatesAutoresizingMaskIntoConstraints = false
        bigLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor).isActive = true
        bigLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bigLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bigLabel.bottomAnchor.constraint(equalTo: bottomLabel.topAnchor).isActive = true
        
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
    }
}
