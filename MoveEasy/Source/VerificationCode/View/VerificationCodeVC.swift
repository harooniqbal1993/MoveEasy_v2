//
//  VerificationCodeVC.swift
//  MoveEasy
//
//  Created by Haroon Iqbal on 15/04/2023.
//

import UIKit

class VerificationCodeVC: UIViewController {

    @IBOutlet weak var verificationCodeTF: UITextField!
    @IBOutlet weak var confirmButton: SpinnerButton!
    
    var verificationCodeViewModel: VerificationCodeViewModel? = nil
    var email: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        loadViews()
    }
    
    func configure() {
        verificationCodeViewModel = VerificationCodeViewModel()
    }
    
    func loadViews() {
        confirmButton.round()
    }
    
    func verifyCode(email: String, code: String) {
        verificationCodeViewModel?.verificationCodeConfirmation(email: email, code: code, completion: { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "Verify Code", message: error)
                    return
                }
                
                let resetPasswordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                resetPasswordVC.email = email
                self?.navigationController?.pushViewController(resetPasswordVC, animated: true)
            }
        })
    }
    
    @IBAction func confirmButtonTapped(_ sender: SpinnerButton) {
        if verificationCodeTF == nil || verificationCodeTF.text?.isEmpty ?? true {
            self.showAlert(title: "Error", message: "Verification code is required!")
            return
        }
        
        confirmButton.setTitle("")
        confirmButton.startLoading()
        
        verifyCode(email: email ?? "", code: verificationCodeTF.text ?? "")
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
