//
//  SigninViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit
import MHLoadingButton

class SigninViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet weak var signinButton: SpinnerButton!
    
    var loginViewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadViews()
    }
    
    func loadViews() {
//        signinButton.isLoading = true
//        signinButton.indicator = MaterialLoadingIndicator(radius: 20, color: Constants.themeColor)
//        signinButton.showLoader(userInteraction: false)
//        signinButton.hideLoader()
        navigationController?.setNavigationBarHidden(true, animated: true)
        signinButton.round()
    }
    
    func configure() {
        loginViewModel = LoginViewModel()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rememberMeButtonTapped(_ sender: UIButton) {
        if loginViewModel.rememberMe {
            checkboxImage.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            checkboxImage.image = UIImage(systemName: "checkmark.square")
        }
        loginViewModel.updateRemeberMe()
    }
    
    @IBAction func signinButtonTapped(_ sender: SpinnerButton) {
        signinButton.startLoading()
        loginViewModel.validate(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { status, error in
            self.signinButton.stopLoading()
            if status == false {
                self.showAlert(title: "Validation", message: error ?? "")
                return
            }
            let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            self.navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        let registerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        navigationController?.pushViewController(registerViewController, animated: true)
    }
}
