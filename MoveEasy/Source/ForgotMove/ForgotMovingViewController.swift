//
//  ForgotMovingViewController.swift
//  MoveEasy
//
//  Created by Apple on 11/12/1443 AH.
//

import UIKit

class ForgotMovingViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViews()
    }
    
    func loadViews() {
        submitButton.round()
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let receiptViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
        navigationController?.pushViewController(receiptViewController, animated: true)
    }
}
