//
//  PickerTableViewCellDelegate.swift
//  PatientApp
//
//  Created by Darien Joso on 4/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

protocol PickerTableViewCellDelegate: AnyObject {
    func useButtonPressed(_ tag: Int)
}
