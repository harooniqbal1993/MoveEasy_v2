//
//  UIButton.swift
//  PlanLoaderiOS
//
//  Created by Apple on 14/06/1443 AH.
//

import Foundation
import UIKit

extension UIButton {
    func rounded() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func bordered(color: UIColor, radius: CGFloat, width: CGFloat) {
        self.layer.masksToBounds =  true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
