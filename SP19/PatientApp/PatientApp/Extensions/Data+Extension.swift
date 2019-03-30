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

//extension Data {
//    struct HexEncodingOptions: OptionSet {
//        let rawValue: Int
//        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
//    }
//
//    func hexEncodedString(options: HexEncodingOptions = []) -> String {
//        let hexDigits = Array((options.contains(.upperCase) ? "0123456789ABCDEF" : "0123456789abcdef").utf16)
//        var chars: [unichar] = []
//        chars.reserveCapacity(2 * count)
//        for byte in self {
//            chars.append(hexDigits[Int(byte / 16)])
//            chars.append(hexDigits[Int(byte % 16)])
//        }
//        return String(utf16CodeUnits: chars, count: chars.count)
//    }
//}
