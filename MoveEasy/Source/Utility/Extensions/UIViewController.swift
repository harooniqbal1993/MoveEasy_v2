//
//  UIViewController.swift
//  PlanLoaderiOS
//
//  Created by Nimra Jamil on 5/11/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
            action in
            print("Alert box shown")
        }))
        self.present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String, completion: @escaping ((Bool) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {
            action in
            completion(false)
        }))
        self.present(alert, animated: true)
    }
}
