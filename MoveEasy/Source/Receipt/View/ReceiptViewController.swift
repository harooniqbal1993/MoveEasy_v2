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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
    }
    
    func loadViews() {
        containerView.round(radius: 20.0)
        continueButton.round()
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
        self.revealViewController().revealToggle(self)
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        let signatureViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "SignatureViewController") as! SignatureViewController
        navigationController?.pushViewController(signatureViewController, animated: true)
    }
}
