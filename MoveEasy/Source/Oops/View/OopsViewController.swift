//
//  OopsViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/11/2022.
//

import UIKit

class OopsViewController: UIViewController {

    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var homepageButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViewa()
    }
    
    func loadViewa() {
        contentView.round(radius: 30.0)
        contentView.addShadow()
        paymentButton.round()
        homepageButton.round()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showPaymentTapped(_ sender: UIButton) {
    }
    
    @IBAction func homepageTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
