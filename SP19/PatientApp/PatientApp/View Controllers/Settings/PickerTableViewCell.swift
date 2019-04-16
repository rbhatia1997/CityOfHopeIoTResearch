//
//  ExercisePickerTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 4/11/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {
    
    var name: String!
    var icon: UIImage!
    var use: Bool!
    var rom: Float!
    var rep: Int16!
    var pickerCellDelegate: PickerTableViewCellDelegate?
    
    private let iconView = UIImageView()
    private let nameLabel = UILabel()
    let useButton = UIButton()
    private let romTitle = UILabel()
    private let romField = UITextField()
    private let repTitle = UILabel()
    private let repField = UITextField()
    
    var romPicker = UIPickerView()
    private var romValues = [Float]()
    var repPicker = UIPickerView()
    private var repValues = [Int16]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        for i in 0...24 { romValues.append(Float(5*i)) }
        for i in 0...50 { repValues.append(Int16(i)) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePickerCell(name: String, icon: UIImage, use: Bool, rom: Float, rep: Int16) {
        self.name = name
        self.icon = icon
        self.use = use
        self.rom = rom
        self.rep = rep
        setupViews()
        setupConstraints()
    }
}

extension PickerTableViewCell: ViewConstraintProtocol, UITextFieldDelegate {
    func setupViews() {
        iconView.frame = .zero
        iconView.image = icon
        self.addSubview(iconView)
        
        nameLabel.setLabelParams(color: .gray, string: name, ftype: defFont, fsize: 16, align: .left)
        self.addSubview(nameLabel)
        
        useButton.setButtonParams(color: use ? .gray : .white, string: "use: \(use!)", ftype: defFont, fsize: 14, align: .center)
        useButton.titleLabel?.numberOfLines = 2
        useButton.setButtonFrame(borderWidth: 1.0, borderColor: use ? .white : .gray, cornerRadius: useButton.frame.height/2, fillColor: use ? .white : .gray, inset: 5)
        useButton.addTarget(self, action: #selector(useButtonTapped), for: .touchUpInside)
        self.addSubview(useButton)
        
        romTitle.setLabelParams(color: .gray, string: " max ROM:", ftype: defFont, fsize: 14, align: .left)
        romTitle.backgroundColor = .white
        self.addSubview(romTitle)
        
        romField.frame = .zero
        romField.backgroundColor = .white
        romField.text = "\(rom!)º"
        romField.font = UIFont(name: defFont, size: 14)!
        romField.textColor = .gray
        romField.textAlignment = .left
        self.addSubview(romField)
        romField.delegate = self
        romField.inputView = romPicker
        
        repTitle.setLabelParams(color: .gray, string: " rep count:", ftype: defFont, fsize: 14, align: .left)
        repTitle.backgroundColor = .white
        self.addSubview(repTitle)
        
        repField.frame = .zero
        repField.backgroundColor = .white
        repField.text = rep == 1 ? "\(rep!) rep" : "\(rep!) reps"
        repField.font = UIFont(name: defFont, size: 14)!
        repField.textColor = .gray
        repField.textAlignment = .left
        self.addSubview(repField)
        romField.delegate = self
        repField.inputView = repPicker
        
        romPicker.delegate = self
        romPicker.dataSource = self
        
        repPicker.delegate = self
        repPicker.dataSource = self
    }
    
    func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor, multiplier: 9/16).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        useButton.translatesAutoresizingMaskIntoConstraints = false
        useButton.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        useButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5).isActive = true
        useButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        romTitle.translatesAutoresizingMaskIntoConstraints = false
        romTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        romTitle.widthAnchor.constraint(equalToConstant: 80).isActive = true
        romTitle.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10).isActive = true
        romTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        romField.translatesAutoresizingMaskIntoConstraints = false
        romField.leadingAnchor.constraint(equalTo: romTitle.trailingAnchor).isActive = true
        romField.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -5).isActive = true
        romField.centerYAnchor.constraint(equalTo: romTitle.centerYAnchor).isActive = true
        romField.heightAnchor.constraint(equalTo: romTitle.heightAnchor).isActive = true
        
        repTitle.translatesAutoresizingMaskIntoConstraints = false
        repTitle.leadingAnchor.constraint(equalTo: romField.trailingAnchor, constant: 5).isActive = true
        repTitle.widthAnchor.constraint(equalToConstant: 80).isActive = true
        repTitle.centerYAnchor.constraint(equalTo: romTitle.centerYAnchor).isActive = true
        repTitle.heightAnchor.constraint(equalTo: romTitle.heightAnchor).isActive = true
        
        repField.translatesAutoresizingMaskIntoConstraints = false
        repField.leadingAnchor.constraint(equalTo: repTitle.trailingAnchor).isActive = true
        repField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        repField.centerYAnchor.constraint(equalTo: romTitle.centerYAnchor).isActive = true
        repField.heightAnchor.constraint(equalTo: romTitle.heightAnchor).isActive = true
    }
}

extension PickerTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case romPicker:
            return 1
        case repPicker:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case romPicker:
            return romValues.count
        case repPicker:
            return repValues.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case romPicker:
            pickerCellDelegate?.setRom(pickerView.tag, romValues[row])
        case repPicker:
            pickerCellDelegate?.setRep(pickerView.tag, repValues[row])
        default:
            break
        }
        updatePickerCell(name: name, icon: icon, use: use, rom: rom, rep: rep)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case romPicker:
            return "\(romValues[row])º"
        case repPicker:
            return repValues[row] == 1 ? "\(repValues[row]) rep" : "\(repValues[row]) reps"
        default:
            return ""
        }
    }
}

extension PickerTableViewCell {
    @objc func useButtonTapped(_ sender: UIButton) {
        pickerCellDelegate?.useButtonPressed(sender.tag)
    }
}
