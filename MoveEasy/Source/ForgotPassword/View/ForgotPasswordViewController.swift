//
//  ForgotPasswordViewController.swift
//  MoveEasy
//
//  Created by Apple on 04/11/2022.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: SpinnerButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViews()
    }
    
    func loadViews() {
        submitButton.round()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: SpinnerButton) {
        if !(emailTextField.text?.isEmpty ?? true) {
            print("not empty")
        }
    }
}
