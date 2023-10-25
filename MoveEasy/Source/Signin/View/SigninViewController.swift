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
            
            if !(DriverSession.shared.driver?.isVerified ?? false) || !(DriverSession.shared.driver?.allDocsUploaded ?? false) || !(DriverSession.shared.driver?.isApproved ?? false) {
                let customPopup: CustomPopup = CustomPopup()
                customPopup.appear(sender: self)
                return
            }
            
//            if DriverSession.shared.driver?.isVerified == false {
//                let verificationCodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificationCodeVC") as! VerificationCodeVC
//                verificationCodeVC.email = self.emailTextField.text
//                self.navigationController?.pushViewController(verificationCodeVC, animated: true)
//                return
//            }
//
//            if !(DriverSession.shared.driver?.allDocsUploaded ?? false) {
//                if let url = URL(string: "https://moversignup.moovez.ca/driver/mobile/registration/\(DriverSession.shared.driver?.id ?? 0)?token=\(Defaults.authToken ?? "")") {
//                    print(url)
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//                return
//            }
//
//            if !(DriverSession.shared.driver?.isApproved ?? false) {
//                self.showAlert(title: "Approval", message: "Approval is pending")
//                return
//            }
            

            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://moversignup.moovez.ca/Driver/MooverSignUp") {
            UIApplication.shared.open(url)
        }
//        let registerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
//        navigationController?.pushViewController(registerViewController, animated: true)
    }
}
