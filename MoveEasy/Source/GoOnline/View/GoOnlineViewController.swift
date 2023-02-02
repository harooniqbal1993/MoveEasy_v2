//
//  GoOnlineViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit
import UIView_Shimmer

class GoOnlineViewController: UIViewController {

    @IBOutlet weak var pickupMapIcon: UIImageView!
    @IBOutlet weak var dropoffMapIcon: UIImageView!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var dropoffLabel: UILabel!
    @IBOutlet weak var dropoffAddressLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var goOnlineButton: UIButton!
    @IBOutlet weak var sideMenuButton: UIButton!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            pickupMapIcon,
            pickupLabel,
            pickupAddressLabel,
            dropoffMapIcon,
            dropoffLabel,
            dropoffAddressLabel
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
        
    }
    
    func loadViews() {
        addressView.setTemplateWithSubviews(true, viewBackgroundColor: .systemBackground)
        goOnlineButton.round()
        sideMenuButton.bordered(color: .systemGray4, radius: 5.0, width: 1.0)
        
    }
    
    @IBAction func goOnlineButtonTapped(_ sender: UIButton) {
//        let jobDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JobDetailViewController") as! JobDetailViewController
//        let sheetController = SheetViewController(controller: jobDetailViewController, sizes:[.percent(0.6)], options: Constants.fittedSheetOptions)
//        sheetController.cornerRadius = 0
//        self.present(sheetController, animated: true, completion: nil)
        Defaults.driverStatus = true
        DriverSession.shared.setDriverStatus(status: true)
//        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        self.revealViewController().revealToggle(self)
    }
}
