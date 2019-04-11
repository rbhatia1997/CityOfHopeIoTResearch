//
//  Data+Extension.swift
//  PatientApp
//
//  Created by Darien Joso on 3/29/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
