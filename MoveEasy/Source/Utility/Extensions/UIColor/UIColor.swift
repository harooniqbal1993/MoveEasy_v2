//
//  UIColor.swift
//  PlanLoaderiOS
//
//  Created by Nimra Jamil on 7/5/22.
//

import Foundation
import UIKit

public extension UIColor {
    
    static func from(hexString: String) -> UIColor {
        var cleanString = hexString.replacingOccurrences(of: "#", with: "")
        
        if cleanString.count == 3 {
            var updatedString = ""
            cleanString.forEach({ updatedString.append("\($0)\($0)") })
            cleanString = updatedString
        }
        
        if cleanString.count == 6 {
            cleanString = cleanString.appending("ff")
        }
        
        var baseValue: UInt32 = 0
        Scanner(string: cleanString).scanHexInt32(&baseValue)
        
        let red = CGFloat((baseValue >> 24) & 0xFF)/255.0
        let green = CGFloat((baseValue >> 16) & 0xFF)/255.0
        let blue = CGFloat((baseValue >> 8) & 0xFF)/255.0
        let alpha = CGFloat((baseValue >> 0) & 0xFF)/255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
