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
    @IBOutlet weak var continueButton: UIButton!
    
    var receiptViewModel: ReceiptViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadViews()
    }
    
    func configure() {
        receiptViewModel = ReceiptViewModel()
    }
    
    func loadViews() {
        containerView.round(radius: 20.0)
        continueButton.round()
        
        updateUI()
    }
    
    func updateUI() {
        orderNumberLabel.text = receiptViewModel?.orderNumber
        baseFareValueLabel.text = "\(receiptViewModel?.baseFare ?? 0.0)"
        distanceValueLabel.text = "\(receiptViewModel?.distance ?? 0.0)"
        subtotalValueLabel.text = "\(receiptViewModel?.subTotal ?? 0.0)"
        gstValueLabel.text = "\(receiptViewModel?.gst ?? 0.0)"
        chargesLabel.text = "\(receiptViewModel?.total ?? 0.0)"
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
//        self.revealViewController().revealToggle(self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        let signatureViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "SignatureViewController") as! SignatureViewController
        navigationController?.pushViewController(signatureViewController, animated: true)
    }
}
