//
//  ResetPasswordVC.swift
//  MoveEasy
//
//  Created by Haroon Iqbal on 15/04/2023.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var confirmButton: SpinnerButton!
    
    var resetPasswordViewModel: ResetPasswordViewModel? = nil
    var email:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        loadViews()
    }
    
    func configure() {
        resetPasswordViewModel = ResetPasswordViewModel()
    }
    
    func loadViews() {
        confirmButton.round()
    }
    
    func resetPassword(password: String) {
        resetPasswordViewModel?.resetPassword(email: email, password: password, completion: { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "Reset Password", message: error)
                    return
                }
                self?.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    @IBAction func confirmButtonTapped(_ sender: SpinnerButton) {
        confirmButton.startLoading()
        
        if passwordTF == nil || passwordTF.text?.isEmpty ?? true || confirmPasswordTF == nil || confirmPasswordTF.text?.isEmpty ?? true {
            self.showAlert(title: "Error", message: "All fields are required!")
            return
        }
        
        if passwordTF.text != confirmPasswordTF.text {
            self.showAlert(title: "Error", message: "Password and confirm password must be same")
            return
        }
        
        resetPassword(password: passwordTF.text ?? "")
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
