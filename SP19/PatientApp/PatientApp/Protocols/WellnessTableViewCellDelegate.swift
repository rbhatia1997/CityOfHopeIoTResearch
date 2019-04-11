//
//  WellnessTableViewCellDelegate.swift
//  PatientApp
//
//  Created by Darien Joso on 4/1/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

protocol WellnessTableViewCellDelegate : AnyObject {
    func yesNoInteract(_ tag: Int)
    func sliderInteract(_ tag: Int)
}
