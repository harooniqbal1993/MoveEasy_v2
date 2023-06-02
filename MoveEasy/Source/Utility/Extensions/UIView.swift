//
//  UIView.swift
//  PlanLoaderiOS
//
//  Created by Apple on 14/06/1443 AH.
//

import Foundation
import UIKit

extension UIView {
    
    func round() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func round(radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func border(color: UIColor, radius: CGFloat, width: CGFloat) {
        self.layer.masksToBounds =  true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
    }
    
    func border(color: UIColor = UIColor.systemGray4, width: CGFloat = 2) {
        self.layer.masksToBounds =  true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    }
    
    func addBorderAndShadow(color: UIColor = UIColor.systemGray4, width: CGFloat = 2){
        self.layer.masksToBounds =  true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.layer.masksToBounds = false
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = masked
//            self.layer.borderColor = UIColor.systemGray4.cgColor
//            self.layer.borderWidth = 0.5
        }
        else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    enum dashedOrientation {
        case horizontal
        case vertical
    }
    
    func makeDashedBorderLine(color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat, orientation: dashedOrientation) {
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        if orientation == .vertical {
            path.addLines(between: [CGPoint(x: bounds.midX, y: bounds.minY),
                                    CGPoint(x: bounds.midX, y: bounds.maxY)])
        } else if orientation == .horizontal {
            path.addLines(between: [CGPoint(x: bounds.minX, y: bounds.midY),
                                    CGPoint(x: bounds.maxX, y: bounds.midY)])
        }
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func backgroundImage(image: String) {
        let background = UIImage(named: image)
        
        let imageView : UIImageView! = UIImageView(frame: self.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
//        imageView.center = self.center
        self.insertSubview(imageView, at: 0)
    }
}
