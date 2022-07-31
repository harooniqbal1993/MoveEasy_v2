//
//  JobDetailViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit

class JobDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var dropoffAddressLabel: UILabel!
    @IBOutlet weak var connector: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViews()
    }
    
    func loadViews() {
        profileImage.round()
        connector.makeDashedBorderLine(color: Constants.themeColor, strokeLength: 7, gapLength: 5, width: 1, orientation: .vertical)
        acceptButton.round()
        rejectButton.border(color: Constants.themeColor, width: 1.0)
    }
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
    }
}
