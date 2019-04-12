//
//  WellnessTableViewCellDelegate.swift
//  PatientApp
//
//  Created by Darien Joso on 4/1/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

protocol WellnessTableViewCellDelegate : AnyObject {
    func yesInteract(_ tag: Int)
    func noInteract(_ tag: Int)
    func sliderInteract(_ tag: Int, _ value: Float)
}

//extension WellnessTableViewCellDelegate {
//    func getSliderValue(f: Float) -> Float
//}
