//
//  ReceiptViewController.swift
//  MoveEasy
//
//  Created by Apple on 13/12/1443 AH.
//

import UIKit
import FittedSheets
//import RealTimePicker

class ReceiptViewController: UIViewController {
    
    enum ViewType: String {
        case summary = "Edit_Job_Summary"
        case forgotTimer = "Forgot_To_Start_Timer"
    }

    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var baseFareValueLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var subtotalValueLabel: UILabel!
    @IBOutlet weak var gstValueLabel: UILabel!
    @IBOutlet weak var chargesLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var minusTimeButton: UIButton!
    @IBOutlet weak var hourlyValueLabel: UILabel!
    @IBOutlet weak var workTimeValueLabel: UILabel!
    @IBOutlet weak var travelTimeValueLabel: UILabel!
    @IBOutlet weak var hourlyRateView: UIView!
    @IBOutlet weak var workTimeView: UIView!
    @IBOutlet weak var travelTimeView: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var baseFareView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var startTimeView: UIView!
    @IBOutlet weak var startTimeValueLabel: UILabel!
    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var endTimeValueLabel: UILabel!
    @IBOutlet weak var breakTimeView: UIView!
    @IBOutlet weak var breakTimeValueLabel: UILabel!
    @IBOutlet weak var subTotalView: UIView!
    @IBOutlet weak var gstView: UIView!
    @IBOutlet weak var totalChargesView: UIView!
    @IBOutlet weak var startTimeEditButton: UIButton!
    @IBOutlet weak var endTimeEditButton: UIButton!
    @IBOutlet weak var breakTimeEditButton: UIButton!
    @IBOutlet weak var workTimeEditButton: UIButton!
    @IBOutlet weak var travelTimeEditButton: UIButton!
    @IBOutlet weak var forgotTimerCommentTextview: UITextView!
    @IBOutlet weak var totalJobTimeValueLabel: UILabel!
    
    var timer: Timer? = nil
    var viewType: ViewType? = .summary
    var receiptViewModel: ReceiptViewModel? = nil
    var orderID: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNotificationCenter()
    }
    
    func configure() {
        receiptViewModel = ReceiptViewModel(receiptModel: nil)
        receiptViewModel?.formType = viewType?.rawValue
        if viewType == .summary {
            registerNotificationCenter()
            getOrderSummary()
        }
        updateUI()
    }
    
    func registerNotificationCenter() {
        NotificationCenter.default
            .addObserver(self,
                         selector:#selector(openReceiptView(_:)),
                         name: Constants.NotificationObserver.OPEN_RECEIPT_VIEW.value, object: nil)
    }
    
    func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: Constants.NotificationObserver.OPEN_TRIPVIEW.value, object: nil)
    }
    
    func loadViews() {
        containerView.round(radius: 20.0)
        acceptButton.round()
        rejectButton.border(color: Constants.themeColor, width: 1.0)
//        minusTimeButton.border(color: Constants.themeColor, radius: 5.0, width: 1.0)
        
//        startTimeEditButton.isHidden = true
//        endTimeEditButton.isHidden = true
//        breakTimeEditButton.isHidden = true
//        workTimeEditButton.isHidden = true
//        travelTimeEditButton.isHidden = true
        
        if viewType == .forgotTimer {
            pageTitleLabel.text = "Forgot Timer"
            acceptButton.setTitle("Submit", for: .normal)
            forgotTimerCommentTextview.isHidden = false
            forgotTimerCommentTextview.border(color: .systemGray4, radius: 0.0, width: 1.0)
            rejectButton.isHidden = true
            
        } else {
            pageTitleLabel.text = "Job Summary"
            acceptButton.setTitle("Accept", for: .normal)
            forgotTimerCommentTextview.isHidden = true
            rejectButton.isHidden = false
        }
    }
    
    func updateUI() {
//        timeValueLabel.text = "\(receiptViewModel?.time ?? 0) min"
        orderNumberLabel.text = receiptViewModel?.orderNumber
//        baseFareValueLabel.text = "\(receiptViewModel?.baseFare ?? "0.0")"
//        distanceValueLabel.text = "\(receiptViewModel?.distance ?? "0.0")"
//        hourlyValueLabel.text = "\(receiptViewModel?.hourlyRate ?? "0.0")"
//        workTimeValueLabel.text = "\(receiptViewModel?.workTime ?? "0.0")"
        startTimeValueLabel.text = "\(getFormattedDate(rawDate: receiptViewModel?.startTime ?? "0.00", fromFormatter: "HH:mm:ss", formatter: "hh:mm a") ?? "0.00")"
        breakTimeValueLabel.text = "\(receiptViewModel?.breakTime ?? 0.00)"
        endTimeValueLabel.text = "\(getFormattedDate(rawDate: receiptViewModel?.endTime ?? "0.00", fromFormatter: "HH:mm:ss", formatter: "hh:mm a") ?? "0.00")"
        travelTimeValueLabel.text = "\(receiptViewModel?.travelTime ?? 0.5)"
        totalJobTimeValueLabel.text = "\(receiptViewModel?.totalJobTime ?? 0.00)"
//        subtotalValueLabel.text = "\(receiptViewModel?.subTotal ?? "0.0")"
//        gstValueLabel.text = "\(receiptViewModel?.gst ?? "0.0")"
//        chargesLabel.text = "\(receiptViewModel?.total ?? "0.0")"
        
        
        
        acceptButton.isHidden = OrderSession.shared.bookingModel?.status == .COMPLETED
        
//        minusTimeButton.isHidden = OrderSession.shared.bookingModel?.type?.lowercased() == "Delivery".lowercased()
//        timeView.isHidden = true
//        baseFareView.isHidden = true
//        distanceView.isHidden = true
//        hourlyRateView.isHidden = true
//        subTotalView.isHidden = true
//        gstView.isHidden = true
//        totalChargesView.isHidden = true
        
//        if (OrderSession.shared.bookingModel?.type?.lowercased() == "Delivery".lowercased()) {
//            minusTimeButton.isHidden = true
//            timeView.isHidden = true
//            baseFareView.isHidden = true
//            distanceView.isHidden = true
//            hourlyRateView.isHidden = true
//        } else {
//            hourlyRateView.isHidden = false
//            workTimeView.isHidden = true
//            travelTimeView.isHidden = true
//        }
    }
    
    func updateCalculations() {
        receiptViewModel?.totalCalculations()
        self.totalJobTimeValueLabel.text = "\(self.receiptViewModel?.totalJobTime ?? 0.00)"
    }
    
    func getOrderSummary() {
//        receiptViewModel?.getOrderSummary(completion: { [weak self] error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self?.showAlert(title: "Error", message: error)
//                    return
//                }
//
//                self?.updateUI()
//            }
//        })
        var id: String? = nil
        if orderID != nil {
            id = orderID
        } else {
            id = "\(OrderSession.shared.order?.id ?? 0)"
        }
        receiptViewModel?.getBooking(bookingID: id, completion: { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "Error", message: error)
                    return
                }

                self?.updateUI()
            }
        })
    }
    
    func chargePayment() {
        receiptViewModel?.chargePayment(completion: { error in
            if let error = error {
                self.showAlert(title: "Card Details", message: error)
                return
            }
//            let signatureViewController = Constants.kJob.instantiateViewController(withIdentifier: "WelldoneViewController") as! WelldoneViewController
//            self.navigationController?.pushViewController(signatureViewController, animated: true)
            
            let feedBackViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
            feedBackViewController.feedbackViewModel = FeedbackViewModel()
            let sheetController = SheetViewController(controller: feedBackViewController, sizes:[.marginFromTop(150.0)], options: Constants.fittedSheetOptions)
            sheetController.cornerRadius = 0
            feedBackViewController.onDismiss = { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            self.present(sheetController, animated: true, completion: nil)
        })
    }
    
    func forgotTimer() {
//        if !(receiptViewModel?.compareDates() ?? false) {
//            self.showAlert(title: "Forgot moving", message: "End date must be greater than start date.")
//            return
//        }
        receiptViewModel?.forgotTimer(completion: { error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.showAlert(title: "Forgot moving", message: error)
                    return
                }
                
                if self?.viewType == .summary {
                    self?.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true,
                                                       block: { (t) in
                        print("Timer called")
                        self?.getCustomerResponse()
                        if self?.receiptViewModel?.isApprovedByCustomer == true {
                            self?.timer?.invalidate()
                            self?.timer = nil
                            self?.chargePayment()
                        }
                    })
                } else {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    func getCustomerResponse() {
        receiptViewModel?.getCustomerResponse(completion: { error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.showAlert(title: "Customer Response", message: error)
                    return
                }
                if self?.receiptViewModel?.isApprovedByCustomer == true {
                    self?.chargePayment()
                }
            }
        })
    }
    
    func showPaymentAlert() {
        let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewController.statusType = .chargePayment
        alertViewController.completion = { [weak self] isYes in
            if isYes {
//                self?.chargePayment()
                self?.forgotTimer()
            } else {
//                self?.acceptButton.setTitle("Continue")
            }
        }
        present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
//        self.revealViewController().revealToggle(self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        if viewType == .summary {
//            showPaymentAlert()
            chargePayment()
        } else {
            forgotTimer()
        }
        
        
//        if acceptButton.currentTitle == "Adjust time" {
//            let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
//            alertViewController.statusType = .adjustTimer
//            alertViewController.completion = { [weak self] isYes in
//                if isYes {
//                    self?.receiptViewModel?.adjustTime(completion: { error in
//                        if let error = error {
//                            self?.showAlert(title: "Error", message: error)
//                        }
//                        self?.updateUI()
//                        self?.acceptButton.setTitle("Continue")
//                    })
//                } else {
//                    self?.acceptButton.setTitle("Continue")
//                }
//            }
//            present(alertViewController, animated: true, completion: nil)
//        } else {
//            chargePayment()
//        }
        
//        let signatureViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "SignatureViewController") as! SignatureViewController
//        let signatureViewController = Constants.kJob.instantiateViewController(withIdentifier: "WelldoneViewController") as! WelldoneViewController
//        navigationController?.pushViewController(signatureViewController, animated: true)
    }
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        showPaymentAlert()
//        forgotTimer()
        
//        let forgotViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ForgotMovingViewController") as! ForgotMovingViewController
//        forgotViewController.forgotMovingViewModel = ForgotMovingViewModel()
//        navigationController?.pushViewController(forgotViewController, animated: true)
        
//        startTimeEditButton.isHidden = false
//        endTimeEditButton.isHidden = false
//        breakTimeEditButton.isHidden = false
//        workTimeEditButton.isHidden = false
//        travelTimeEditButton.isHidden = false
        
//        let signatureViewController = Constants.kJob.instantiateViewController(withIdentifier: "OopsViewController") as! OopsViewController
//        navigationController?.pushViewController(signatureViewController, animated: true)
    }
    
    @IBAction func startTimeTapped(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [weak self](selectedDate) in
            print(selectedDate.dateString("HH:mm:ss"))
            self?.receiptViewModel?.startTime = selectedDate.dateString("HH:mm:ss")
            self?.startTimeValueLabel.text = "\(getFormattedDate(rawDate: selectedDate.dateString("HH:mm:ss"), fromFormatter: "HH:mm:ss", formatter: "hh:mm a") ?? "0.00")"
            self?.updateCalculations()
        })
    }
    
    @IBAction func breakTimeTapped(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .countDownTimer, didSelectDate: { [weak self](selectedDate) in
            print(selectedDate.dateString("HH:mm:ss"))
            self?.receiptViewModel?.breakTime = self?.receiptViewModel?.hoursStringToDecimal(selectedDate.dateString("HH:mm"))
            self?.breakTimeValueLabel.text = "\(self?.receiptViewModel?.breakTime ?? 0.0)"
            self?.updateCalculations()
        })
    }
    
    @IBAction func endTimeTapped(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [weak self](selectedDate) in
            print(selectedDate.dateString("HH:mm:ss"))
            self?.receiptViewModel?.endTime = selectedDate.dateString("HH:mm:ss")
            self?.endTimeValueLabel.text = "\(getFormattedDate(rawDate: selectedDate.dateString("HH:mm:ss"), fromFormatter: "HH:mm:ss", formatter: "hh:mm a") ?? "0.00")"
            self?.updateCalculations()
        })
    }
    
    @IBAction func travelTimeTapped(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .countDownTimer, didSelectDate: { [weak self](selectedDate) in
            self?.receiptViewModel?.travelTime = self?.receiptViewModel?.hoursStringToDecimal(selectedDate.dateString("HH:mm"))
            self?.travelTimeValueLabel.text = "\(self?.receiptViewModel?.travelTime ?? 0.0)"
            self?.updateCalculations()
        })
    }
    
    @IBAction func minusTimeButtonTapped(_ sender: UIButton) {
        receiptViewModel?.decreaseTime()
        timeValueLabel.text = "\(receiptViewModel?.time ?? 0) min"
        if receiptViewModel?.isAdjustNeeded == true {
            acceptButton.setTitle("Adjust time")
        }
    }
    
    @objc func openReceiptView(_ notification: Notification) {
        if let response = notification.userInfo?["response"] as? Int {
            if response == 1 {
                let signatureViewController = Constants.kJob.instantiateViewController(withIdentifier: "WelldoneViewController") as! WelldoneViewController
                navigationController?.pushViewController(signatureViewController, animated: true)
            } else {
                let signatureViewController = Constants.kJob.instantiateViewController(withIdentifier: "OopsViewController") as! OopsViewController
                navigationController?.pushViewController(signatureViewController, animated: true)
            }
        }
    }
}
