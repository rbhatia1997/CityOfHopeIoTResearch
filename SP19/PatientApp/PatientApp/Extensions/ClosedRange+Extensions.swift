//
//  ClosedRange+Extensions.swift
//  PatientApp
//
//  Created by Darien Joso on 4/3/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

extension ClosedRange where Bound: FixedWidthInteger {
    func randomElements(_ n: Int) -> [Bound] {
        guard n > 0 else { return [] }
        return (0..<n).map { _ in Bound.random(in: self) }
    }
    var randomElement: Bound { return Bound.random(in: self) }
}
