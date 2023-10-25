//
//  ReceiptViewController.swift
//  MoveEasy
//
//  Created by Apple on 13/12/1443 AH.
//

import UIKit

class ReceiptViewController: UIViewController {

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
        registerNotificationCenter()
        receiptViewModel = ReceiptViewModel(receiptModel: nil)
        
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
        minusTimeButton.border(color: Constants.themeColor, radius: 5.0, width: 1.0)
        
        updateUI()
        
        getOrderSummary()
    }
    
    func updateUI() {
        timeValueLabel.text = "\(receiptViewModel?.time ?? 0) min"
        orderNumberLabel.text = receiptViewModel?.orderNumber
        baseFareValueLabel.text = "\(receiptViewModel?.baseFare ?? "0.0")"
        distanceValueLabel.text = "\(receiptViewModel?.distance ?? "0.0")"
        hourlyValueLabel.text = "\(receiptViewModel?.hourlyRate ?? "0.0")"
        workTimeValueLabel.text = "\(receiptViewModel?.workTime ?? "0.0")"
        travelTimeValueLabel.text = "\(receiptViewModel?.travelTime ?? "0.0")"
        subtotalValueLabel.text = "\(receiptViewModel?.subTotal ?? "0.0")"
        gstValueLabel.text = "\(receiptViewModel?.gst ?? "0.0")"
        chargesLabel.text = "\(receiptViewModel?.total ?? "0.0")"
        
        acceptButton.isHidden = OrderSession.shared.bookingModel?.status == .COMPLETED
        
        if (OrderSession.shared.bookingModel?.type?.lowercased() == "Delivery".lowercased()) {
            minusTimeButton.isHidden = true
            timeView.isHidden = true
            baseFareView.isHidden = true
            distanceView.isHidden = true
            hourlyRateView.isHidden = true
        } else {
            hourlyRateView.isHidden = false
            workTimeView.isHidden = true
            travelTimeView.isHidden = true
        }
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
//        receiptViewModel?.getBooking(bookingID: "1306", completion: { [weak self] error in
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
            let signatureViewController = Constants.kJob.instantiateViewController(withIdentifier: "WelldoneViewController") as! WelldoneViewController
            self.navigationController?.pushViewController(signatureViewController, animated: true)
        })
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
//        self.revealViewController().revealToggle(self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        if acceptButton.currentTitle == "Adjust time" {
            let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
            alertViewController.statusType = .adjustTimer
            alertViewController.completion = { [weak self] isYes in
                if isYes {
                    self?.receiptViewModel?.adjustTime(completion: { error in
                        if let error = error {
                            self?.showAlert(title: "Error", message: error)
                        }
                        self?.updateUI()
                        self?.acceptButton.setTitle("Continue")
                    })
                } else {
                    self?.acceptButton.setTitle("Continue")
                }
            }
            present(alertViewController, animated: true, completion: nil)
        } else {
            chargePayment()
        }
        
//        let signatureViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "SignatureViewController") as! SignatureViewController
//        let signatureViewController = Constants.kJob.instantiateViewController(withIdentifier: "WelldoneViewController") as! WelldoneViewController
//        navigationController?.pushViewController(signatureViewController, animated: true)
    }
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        let signatureViewController = Constants.kJob.instantiateViewController(withIdentifier: "OopsViewController") as! OopsViewController
        navigationController?.pushViewController(signatureViewController, animated: true)
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
