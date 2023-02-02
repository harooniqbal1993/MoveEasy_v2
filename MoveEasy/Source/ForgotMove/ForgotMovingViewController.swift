//
//  ForgotMovingViewController.swift
//  MoveEasy
//
//  Created by Apple on 11/12/1443 AH.
//

import UIKit
//import Fastis
import DateTimePicker

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
        //        let fastisController = FastisController(mode: .single)
        //        fastisController.title = "Choose range"
        //        fastisController.maximumDate = Date.distantFuture
        //        fastisController.initialValue = Date()
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "hh:mm:ss" // "dd/MM/yyyy"
        //        fastisController.doneHandler = { [weak self] resultDate in
        //            debugPrint("Selected Date : ", resultDate)
        //            if self?.forgotMovingViewModel?.isStartDateTapped == true {
        //                self?.startTimeTextField.text = formatter.string(from: resultDate!) // "\(resultDate)"
        //            } else {
        //                self?.endTimeTextField.text = formatter.string(from: resultDate!)
        //            }
        //        }
        //        fastisController.present(above: self)
        
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        
        // customize your picker
        //        picker.timeInterval = DateTimePicker.MinuteInterval.thirty
        //        picker.locale = Locale(identifier: "en_GB")
        //        picker.todayButtonTitle = "Today"
        //        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm:ss aa dd/MM/YYYY"
        picker.includesMonth = true
        picker.includesSecond = true
        picker.highlightColor = Constants.themeColor // UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.doneButtonTitle = "DONE"
        picker.doneBackgroundColor = Constants.themeColor // UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.customFontSetting = DateTimePicker.CustomFontSetting(selectedDateLabelFont: .boldSystemFont(ofSize: 20))
        //        if #available(iOS 13.0, *) {
        //            picker.normalColor = UIColor.secondarySystemGroupedBackground
        //            picker.darkColor = UIColor.label
        //            picker.contentViewBackgroundColor = UIColor.systemBackground
        //            picker.daysBackgroundColor = UIColor.groupTableViewBackground
        //            picker.titleBackgroundColor = UIColor.secondarySystemGroupedBackground
        //        } else {
        //            picker.normalColor = UIColor.white
        //            picker.darkColor = UIColor.black
        //            picker.contentViewBackgroundColor = UIColor.white
        //        }
        picker.completionHandler = { [weak self] date in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // 2023-01-31T16:44:58.807Z // "hh:mm:ss aa dd/MM/YYYY"
//            self?.title = formatter.string(from: date)
            
            if self?.forgotMovingViewModel?.isStartDateTapped == true {
                self?.startTimeTextField.text = formatter.string(from: date) // "\(resultDate)"
                self?.forgotMovingViewModel?.startTime = formatter.string(from: date)
            } else {
                self?.endTimeTextField.text = formatter.string(from: date)
                self?.forgotMovingViewModel?.endTime = formatter.string(from: date)
            }
        }
        picker.delegate = self
        
        // add picker to your view
        // don't try to make customize width and height of the picker,
        // you'll end up with corrupted looking UI
        //        picker.frame = CGRect(x: 0, y: 100, width: picker.frame.size.width, height: picker.frame.size.height)
        // set a dismissHandler if necessary
        //        picker.dismissHandler = {
        //            picker.removeFromSuperview()
        //        }
        //        self.view.addSubview(picker)
        
        // or show it like a modal
        picker.show()
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        if !(nameTextField.text?.isEmpty ?? false) && !(emailTextField.text?.isEmpty ?? false) && !(startTimeTextField.text?.isEmpty ?? false) && !(endTimeTextField.text?.isEmpty ?? false) {
            forgotMovingViewModel?.name = nameTextField.text
            forgotMovingViewModel?.email = emailTextField.text
            forgotMovingViewModel?.forgotTimer(completion: { error in
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

extension ForgotMovingViewController: DateTimePickerDelegate {
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(didSelectDate)
    }
}
