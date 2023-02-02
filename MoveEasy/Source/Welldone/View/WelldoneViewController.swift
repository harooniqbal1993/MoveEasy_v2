//
//  WelldoneViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/11/2022.
//

import UIKit
import FittedSheets

class WelldoneViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var moveCompleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews()
    }
    
    func loadViews() {
        contentView.round(radius: 30.0)
        contentView.addShadow()
        moveCompleteButton.round()
    }
    
    @IBAction func moveCompleteButtonTapped(_ sender: UIButton) {
        let feedBackViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
        feedBackViewController.feedbackViewModel = FeedbackViewModel()
        let sheetController = SheetViewController(controller: feedBackViewController, sizes:[.marginFromTop(150.0)], options: Constants.fittedSheetOptions)
        sheetController.cornerRadius = 0
        feedBackViewController.onDismiss = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        self.present(sheetController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
