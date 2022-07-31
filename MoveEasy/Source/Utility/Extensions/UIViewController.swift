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
}
