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
//                let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//                self.navigationController?.pushViewController(mapViewController, animated: true)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.showAlert(title: "Register", message: error ?? "Something went wrong")
            }
        }
    }
}
