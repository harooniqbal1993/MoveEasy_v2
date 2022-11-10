//
//  ForgotMovingViewController.swift
//  MoveEasy
//
//  Created by Apple on 11/12/1443 AH.
//

import UIKit
import Fastis

class ForgotMovingViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var forgotMovingViewModel: ForgotMovingViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadViews()
    }
    
    func configure() {
        startTimeTextField.delegate = self
        endTimeTextField.delegate = self
    }
    
    func loadViews() {
        submitButton.round()
    }
    
    func openDatePicker() {
        let fastisController = FastisController(mode: .single)
        fastisController.title = "Choose range"
        fastisController.maximumDate = Date.distantFuture
        fastisController.initialValue = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss" // "dd/MM/yyyy"
        fastisController.doneHandler = { [weak self] resultDate in
            debugPrint("Selected Date : ", resultDate)
            if self?.forgotMovingViewModel?.isStartDateTapped == true {
                self?.startTimeTextField.text = formatter.string(from: resultDate!) // "\(resultDate)"
            } else {
                self?.endTimeTextField.text = formatter.string(from: resultDate!)
            }
        }
        fastisController.present(above: self)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        if !(nameTextField.text?.isEmpty ?? false) || !(emailTextField.text?.isEmpty ?? false) || !(startTimeTextField.text?.isEmpty ?? false) || !(endTimeTextField.text?.isEmpty ?? false) {
            forgotMovingViewModel?.forgotTimer(bookingID: 1310, startTime: startTimeTextField.text ?? "", endTime: endTimeTextField.text ?? "", completion: { error in
                DispatchQueue.main.async { [weak self] in
                    if let error = error {
                        self?.showAlert(title: "Forgot moving", message: error)
                        return
                    }
                    self?.navigationController?.popViewController(animated: true)
                }
            })
//            let receiptViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
//            navigationController?.pushViewController(receiptViewController, animated: true)
        } else {
            self.showAlert(title: "Validation", message: "All fields are required!")
        }
    }
}

extension ForgotMovingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startTimeTextField || textField == endTimeTextField {
            forgotMovingViewModel?.isStartDateTapped = textField == startTimeTextField
            openDatePicker()
        }
    }
}
