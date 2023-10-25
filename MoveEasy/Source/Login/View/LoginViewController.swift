//
//  LoginViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var punchLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews()
    }
    
    func loadViews() {
        let backgroundImage = UIImage.init(named: "login-driver")
        let backgroundImageView = UIImageView.init(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImageView, at: 0)
        
        signUpButton.border(color: .white, width: 1)
        signInButton.round()
        punchLabel.setSubTextColor(pSubString: "moovez", pColor: UIColor(red: 254/255, green: 190/255, blue: 45/255, alpha: 1.0))
    }
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        
        let signinViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        navigationController?.pushViewController(signinViewController, animated: true)
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://moversignup.moovez.ca/Driver/MooverSignUp") {
            UIApplication.shared.open(url)
        }
//        let signupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
//        navigationController?.pushViewController(signupViewController, animated: true)
    }
}
