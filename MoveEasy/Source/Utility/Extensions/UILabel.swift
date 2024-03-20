//
//  UILabel.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import Foundation
import UIKit

extension UILabel{
    func setSubTextColor(pSubString : String, pColor : UIColor){
        let attributedString: NSMutableAttributedString = self.attributedText != nil ? NSMutableAttributedString(attributedString: self.attributedText!) : NSMutableAttributedString(string: self.text!);
        
        let range = attributedString.mutableString.range(of: pSubString, options:NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: pColor, range: range);
        }
        self.attributedText = attributedString
    }
}

extension UITextField {
    func setPlaceholder(text: String, color: UIColor = .black) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

