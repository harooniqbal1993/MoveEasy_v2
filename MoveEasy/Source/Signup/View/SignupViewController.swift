//
//  SignupViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signupButtonTapped: SpinnerButton!
    @IBOutlet weak var policyButton: UIButton!
    
    var registerViewModel: RegisterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        loadViews()
    }
    
    func loadViews() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        signupButtonTapped.round()
    }
    
    func configure() {
        phoneTextField.delegate = self
        registerViewModel = RegisterViewModel()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerButtonTapped(_ sender: SpinnerButton) {
        signupButtonTapped.startLoading()
        registerViewModel.validate(email: emailTextField.text!, firstName: firstnameTextField.text!, lastName: lastnameTextField.text!, password: passwordTextField.text!, phone: phoneTextField.text!, confirmPassword: confirmPasswordTextField.text!) { status, error in
            self.signupButtonTapped.stopLoading()
            if status {
                if let url = URL(string: "https://moversignup.moovez.ca/driver/mobile/registration/\(self.registerViewModel.driverId ?? 0)?token=\(self.registerViewModel.token ?? "")") {
                    print(url)
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else {
                self.showAlert(title: "Register", message: error ?? "Something went wrong")
            }
        }
    }
    
    @IBAction func policyButtonTapped(_ sender: UIButton) {
        if registerViewModel.isPolicy {
            policyButton.setImage(UIImage(systemName: "checkmark.square.fill"))
//            checkboxImage.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            policyButton.setImage(UIImage(systemName: "checkmark.square"))
//            checkboxImage.image = UIImage(systemName: "checkmark.square")
        }
        registerViewModel.updatePolicy()
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text?.count ?? 0 <= 10
    }
}
