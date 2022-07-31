//
//  SignatureViewController.swift
//  MoveEasy
//
//  Created by Apple on 13/12/1443 AH.
//

import UIKit
import SwiftSignatureView

class SignatureViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signatureView: SwiftSignatureView!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var termsConditionButton: UIButton!
    @IBOutlet weak var tcCheckbox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
    }
    
    func loadViews() {
        containerView.round(radius: 20.0)
        completedButton.rounded()
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
    }
    
    @IBAction func moveCompletedTapped(_ sender: UIButton) {
    }
    
    @IBAction func termsConditionTapped(_ sender: UIButton) {
    }
    
}
