//
//  SignatureViewController.swift
//  MoveEasy
//
//  Created by Apple on 13/12/1443 AH.
//

import UIKit
import SwiftSignatureView
import FittedSheets

class SignatureViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signatureView: SwiftSignatureView!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var termsConditionButton: UIButton!
    @IBOutlet weak var tcCheckbox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
    }
    
    func loadViews() {
        containerView.round(radius: 20.0)
        completedButton.rounded()
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moveCompletedTapped(_ sender: UIButton) {
        let oopsViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "OopsViewController") as! OopsViewController
        navigationController?.pushViewController(oopsViewController, animated: true)
//        let welldoneViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "WelldoneViewController") as! WelldoneViewController
//        navigationController?.pushViewController(welldoneViewController, animated: true)
        
//        let feedBackViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
//        feedBackViewController.feedbackViewModel = FeedbackViewModel()
//        let sheetController = SheetViewController(controller: feedBackViewController, sizes:[.marginFromTop(150.0)], options: Constants.fittedSheetOptions)
//        sheetController.cornerRadius = 0
//        self.present(sheetController, animated: true, completion: nil)
    }
    
    @IBAction func termsConditionTapped(_ sender: UIButton) {
    }
    
}
