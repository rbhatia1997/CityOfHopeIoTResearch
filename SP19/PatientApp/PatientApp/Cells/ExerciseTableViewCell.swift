//
//  ExerciseTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/11/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    // public variables
    public var colorTheme: UIColor!
    public var exerciseIcon: UIImage!
    public var exerciseName: String!
    
    // construction variables
    private let cellView = UIView()
    private let exerciseImage = UIImageView()
    private let exerciseLabel = UILabel()
    private let arrowLabel = UILabel()
    
//    private let checkButton = UIButton()
//    private var isDone: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // setup cell view
        cellView.frame = .zero
        cellView.backgroundColor = .clear
        
        // setup exercise image view
        exerciseImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        exerciseImage.backgroundColor = .clear
        exerciseImage.image = exerciseIcon
        
        // setup exercise label view
        exerciseLabel.setLabelParams(color: .gray, string: exerciseName, ftype: "Montserrat-Regular",
                                     fsize: 16, align: .left)
        
        // setup arrow label view
        arrowLabel.setLabelParams(color: .lightGray, string: ">", ftype: "Montserrat-Regular",
                                  fsize: 20, align: .center)
        
        // add cell view to self
        self.addSubview(cellView)
        
        // add subviews to the cell view
        cellView.addSubview(exerciseImage)
        cellView.addSubview(exerciseLabel)
        cellView.addSubview(arrowLabel)
        
//        checkButton.translatesAutoresizingMaskIntoConstraints = false
//        checkButton.frame = .zero
//        checkButton.setTitle("⭕️", for: .normal)
//        checkButton.setTitleColor(.gray, for: .normal)
//        checkButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)!
//        checkButton.sizeToFit()
//        checkButton.titleLabel?.textAlignment = .center
//        checkButton.addTarget(self, action: #selector(checkButtonPressed), for: .touchUpInside)
        
    }
    
    private func setupConstraints() {
        // setup cell view constraints
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // setup exercise image constraints
        exerciseImage.translatesAutoresizingMaskIntoConstraints = false
        exerciseImage.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5).isActive = true
        exerciseImage.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -5).isActive = true
        exerciseImage.widthAnchor.constraint(equalTo: cellView.heightAnchor, multiplier: 16/9).isActive = true
        exerciseImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
        
        // setup arrow label constraints
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        arrowLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -5).isActive = true
        arrowLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        // setup exercise label constraints
        exerciseLabel.translatesAutoresizingMaskIntoConstraints = false
        exerciseLabel.leadingAnchor.constraint(equalTo: exerciseImage.trailingAnchor).isActive = true
        exerciseLabel.trailingAnchor.constraint(equalTo: arrowLabel.leadingAnchor).isActive = true
        exerciseLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
//        checkButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
//        checkButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        checkButton.leadingAnchor.constraint(equalTo: cellView.leadingAnchor).isActive = true
//        checkButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

//    @objc func checkButtonPressed(_ sender: UIButton) {
//        if isDone {
//            checkButton.setTitle("✅", for: .normal)
//        } else {
//            checkButton.setTitle("⭕️", for: .normal)
//        }
//        isDone = !isDone
//    }
    
    // update everything
    func updateExerciseCell(color: UIColor, icon: UIImage, name: String) {
        colorTheme = color
        exerciseIcon = icon
        exerciseName = name
        setupViews()
        setupConstraints()
    }

}
