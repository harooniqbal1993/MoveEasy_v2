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
    
    var forgotPasswordViewModel: ForgotPasswordViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        loadViews()
    }
    
    func configure() {
        forgotPasswordViewModel = ForgotPasswordViewModel()
    }
    
    func loadViews() {
        submitButton.round()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: SpinnerButton) {
        if !(emailTextField.text?.isValidEmail ?? false) {
            self.showAlert(title: "Email", message: "Enter valid email address")
            return
        }
        
        if !(emailTextField.text?.isEmpty ?? true) {
            forgotPasswordViewModel?.forgotPassword(email: emailTextField.text ?? "") { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.showAlert(title: "Forgot Password", message: error)
                        return
                    }
                    
//                    self?.navigationController?.popViewController(animated: true)
                    let verificationCodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificationCodeVC") as! VerificationCodeVC
                    verificationCodeVC.email = self?.emailTextField.text
                    self?.navigationController?.pushViewController(verificationCodeVC, animated: true)
                }
            }
        }
    }
}
