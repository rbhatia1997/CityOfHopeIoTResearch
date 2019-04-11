//
//  GoalsTableViewCellDelegate.swift
//  PatientApp
//
//  Created by Darien Joso on 4/1/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

protocol GoalsTableViewCellDelegate : AnyObject {
    func doneButtonPressed(_ tag: Int)
}
