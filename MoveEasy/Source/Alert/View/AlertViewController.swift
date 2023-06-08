//
//  AlertViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit

class AlertViewController: UIViewController {
    
    enum StatusType {
        case start
        case paused
        case stopped
        case back
        case adjustTimer
        case deleteAccount
    }

    @IBOutlet weak var warningImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    var alertTitle: String? = nil
    var message: String? = nil
    var completion: ((Bool) -> Void)?
    var statusType: StatusType = .start
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViews()
    }
    
    func loadViews() {
        containerView.round(radius: 20.0)
        yesButton.round()
        noButton.border(color: Constants.themeColor, width: 1.0)
        
        updateLabels()
        
//        if let alertTitle = alertTitle {
//            titleLabel.text = alertTitle
//        }
//
//        if let message = message {
//            messageLabel.text = message
//        }
    }
    
    func updateLabels() {
        
        if statusType == .start {
            warningImageView.image = UIImage(named: "play")
            titleLabel.text = "Are you ready to start?"
            messageLabel.text = "Make contact with the customer before you start the clock."
        } else if statusType == .paused {
            warningImageView.image = UIImage(named: "pause")
            titleLabel.text = "Did you mean to pause?"
            messageLabel.text = "This is meant for lunch breaks or any other breaks during the move."
        } else if statusType == .back {
            warningImageView.image = UIImage(named: "warning")
            titleLabel.text = "Are you sure you want exit?"
            messageLabel.text = "If you exit clock will stop."
        } else if statusType == .adjustTimer {
            warningImageView.image = UIImage(named: "warning")
            titleLabel.text = "Adjust time"
            messageLabel.text = "Are you sure you want to adjust time"
        } else if statusType == .deleteAccount {
            containerHeightConstraint.constant = 350
            warningImageView.image = UIImage(named: "red-cross")
            titleLabel.text = "Delete Account"
            messageLabel.text = "Are you sure you want to delete your account?\n\nThis action is irreversible and will permanently remove all your data and associated information."
        } else {
            warningImageView.image = UIImage(named: "stop")
            titleLabel.text = "Did you finish the job?"
            messageLabel.text = "Please wait until the job is complete before you submit this form for customer approval."
        }
    }
    
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        completion?(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noButtonTapped(_ sender: UIButton) {
        completion?(false)
        dismiss(animated: true, completion: nil)
    }
}
