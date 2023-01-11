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
    
    var receiptViewModel: ReceiptViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configure()
        loadViews()
    }
    
    func configure() {
//        receiptViewModel = ReceiptViewModel()
    }
    
    func loadViews() {
        containerView.round(radius: 20.0)
        acceptButton.round()
        rejectButton.border(color: Constants.themeColor, width: 1.0)
        
        updateUI()
        
        getOrderSummary()
    }
    
    func updateUI() {
        orderNumberLabel.text = receiptViewModel?.orderNumber
        baseFareValueLabel.text = "\(receiptViewModel?.baseFare ?? "0.0")"
        distanceValueLabel.text = "\(receiptViewModel?.distance ?? "0.0")"
        subtotalValueLabel.text = "\(receiptViewModel?.subTotal ?? "0.0")"
        gstValueLabel.text = "\(receiptViewModel?.gst ?? "0.0")"
        chargesLabel.text = "\(receiptViewModel?.total ?? "0.0")"
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
        
        receiptViewModel?.getBooking(bookingID: "\(OrderSession.shared.order?.id ?? 0)", completion: { [weak self] error in
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
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
//        self.revealViewController().revealToggle(self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
//        let signatureViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "SignatureViewController") as! SignatureViewController
        let signatureViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "WelldoneViewController") as! WelldoneViewController
        navigationController?.pushViewController(signatureViewController, animated: true)
    }
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        let signatureViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "OopsViewController") as! OopsViewController
        navigationController?.pushViewController(signatureViewController, animated: true)
    }
}
