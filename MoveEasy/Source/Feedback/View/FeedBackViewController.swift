//
//  FeedBackViewController.swift
//  MoveEasy
//
//  Created by Apple on 13/12/1443 AH.
//

import UIKit
import FittedSheets

class FeedBackViewController: UIViewController {

    @IBOutlet var filterButton: [UIButton]!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var appreciatiionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var customButtonView: UIView!
    @IBOutlet weak var Cad3ButtonView: UIView!
    @IBOutlet weak var cad1ButtonView: UIView!
    @IBOutlet weak var notThisTimeButtonView: UIView!
    
    
    let textColor: UIColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
    
    var feedbackViewModel: FeedbackViewModel? = nil
    var onDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViews()
    }
    
    func loadViews() {
        filterButton.forEach { button in
            button.border(color: .systemGray4, radius: 5, width: 2.0)
            button.addTarget(self, action: #selector(filterButtonTapped(_sender:)), for: .touchUpInside)
        }
        customButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        cad1ButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        Cad3ButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        notThisTimeButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        addCommentButton.border(color: Constants.themeColor, radius: 6, width: 1.0)
        commentTextView.border(color: textColor, radius: 0.0, width: 1.0)
        submitButton.round()
        ratingStarListeners()
    }
    
    func ratingStarListeners() {
        ratingView.didFinishTouchingCosmos = { rating in
            self.appreciatiionLabel.text = self.appreciationValue(rating: rating)
        }

        ratingView.didTouchCosmos = { rating in
            self.appreciatiionLabel.text = self.appreciationValue(rating: rating)
        }
    }
    
    func appreciationValue(rating: Double) -> String {
        feedbackViewModel?.rating = rating
        switch rating {
        case 5:
            return "Excellent"
        case 4:
            return "Very good"
        case 3:
            return "Good"
        case 2:
            return "Fair"
        default:
            return "Poor"
        }
    }
    
    @objc func filterButtonTapped(_sender: UIButton) {
        filterButton.forEach { button in
            button.backgroundColor = .clear
            button.setTitleColor(textColor, for: .normal)
            button.border(color: .systemGray4, radius: 5, width: 2.0)
        }
        
        _sender.backgroundColor = Constants.themeColor
        _sender.setTitleColor(.white, for: .normal)
        _sender.border(color: Constants.themeColor, radius: 5, width: 2.0)
        
        self.sheetViewController?.setSizes([.marginFromTop(0.0)])
    }
    
    @IBAction func addCommentTapped(_ sender: UIButton) {
        sender.isHidden = true
        commentTextView.isHidden = false
        
        self.sheetViewController?.setSizes([.marginFromTop(0.0)])
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        feedbackViewModel?.submitFeedback(rating: Int(feedbackViewModel?.rating ?? 3), comments: commentTextView.text, userID: 0, completion: { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "Error", message: error)
                    return
                }
                self?.dismiss(animated: true, completion: {
                    self?.onDismiss?()
                })
                
//                self?.dismiss(animated: true, completion: {
//                    let homeViewController: SWRevealViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//                    let nav = UINavigationController(rootViewController: homeViewController)
//                    let scenes = UIApplication.shared.connectedScenes
//                    let windowScene = scenes.first as? UIWindowScene
//                    let window = windowScene?.windows.first
//                    window?.rootViewController = nav
//                })
            }
        })
//        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func customButtonTapped(_ sender: UIButton) {
        customButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        cad1ButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        Cad3ButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        notThisTimeButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        
        customButtonView.border(color: Constants.themeColor, radius: 5, width: 2.0)
    }
    
    @IBAction func cad1Tapped(_ sender: UIButton) {
        customButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        cad1ButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        Cad3ButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        notThisTimeButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        
        cad1ButtonView.border(color: Constants.themeColor, radius: 5, width: 2.0)
    }
    
    @IBAction func cad3Tapped(_ sender: UIButton) {
        customButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        cad1ButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        Cad3ButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        notThisTimeButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        
        Cad3ButtonView.border(color: Constants.themeColor, radius: 5, width: 2.0)
    }
    
    @IBAction func notThisTimeTapped(_ sender: UIButton) {
        customButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        cad1ButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        Cad3ButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        notThisTimeButtonView.border(color: .systemGray4, radius: 5, width: 2.0)
        
        notThisTimeButtonView.border(color: Constants.themeColor, radius: 5, width: 2.0)
    }
}
