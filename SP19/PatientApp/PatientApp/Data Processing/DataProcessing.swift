//
//  DataProcessing.swift
//  PatientApp
//
//  Created by Darien Joso on 4/2/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

func dataToFloats(data: Data, numFloats n: Int) -> [Float] {
    var f = [Float]()
    
    let str: String = String(data: data, encoding: .utf8) ?? ""
    
    if str.count != 8*n { return f }
    
    var lower = str.index(str.startIndex, offsetBy: 0)
    var upper: String.Index!
    
    var range: ClosedRange<String.Index>!
    var substr = Substring()
    
    var tempstr: String!
    
    for _ in 0..<n {
        upper = str.index(lower, offsetBy: 7)
        range = lower...upper
        substr = Substring(str)[range]
        tempstr = String(substr)
        f.append(Float(bitPattern: UInt32(tempstr, radix: 16) ?? 120))
        lower = str.index(upper, offsetBy: 1)
    }
    
    return f
}
