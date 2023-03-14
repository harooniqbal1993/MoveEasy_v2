//
//  AdjustTimeViewController.swift
//  MoveEasy
//
//  Created by Nimra Jamil on 3/2/23.
//

import UIKit

class AdjustTimeViewController: UIViewController {

    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var adjustButton: UIButton!
    
    var adjustTimeViewModel: AdjustTimeViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadViews()
    }
    
    func configure() {
        adjustTimeViewModel = AdjustTimeViewModel()
        timeTextField.delegate = self
//        timeTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func loadViews() {
        timeTextField.text = "\(adjustTimeViewModel?.actualTime ?? 0)"
        adjustButton.round()
    }
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        adjustTimeViewModel?.decreaseTime()
        timeTextField.text = "\(adjustTimeViewModel?.time ?? 0)"
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        adjustTimeViewModel?.increaseTime()
        timeTextField.text = "\(adjustTimeViewModel?.time ?? 0)"
    }
    
    @IBAction func adjustButtonTapped(_ sender: UIButton) {
        adjustTimeViewModel?.adjustTime(completion: { error in
            if let error = error {
                self.showAlert(title: "Error", message: error)
            }
            self.dismiss(animated: true)
        })
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension AdjustTimeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        adjustTimeViewModel?.time = Int(newText) ?? 0
        return (Int(newText) ?? 0 <= adjustTimeViewModel?.actualTime ?? 0) // newText.count <= 4
    }
}
