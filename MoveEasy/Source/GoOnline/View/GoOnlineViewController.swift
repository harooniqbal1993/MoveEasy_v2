//
//  GoOnlineViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit
import FittedSheets

class GoOnlineViewController: UIViewController {

    @IBOutlet weak var goOnlineButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
        
    }
    
    func loadViews() {
        goOnlineButton.round()
    }
    
    @IBAction func goOnlineButtonTapped(_ sender: UIButton) {
        let jobDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JobDetailViewController") as! JobDetailViewController
        let sheetController = SheetViewController(controller: jobDetailViewController, sizes:[.percent(0.6)], options: Constants.fittedSheetOptions)
        sheetController.cornerRadius = 0
        self.present(sheetController, animated: true, completion: nil)
    }
}
