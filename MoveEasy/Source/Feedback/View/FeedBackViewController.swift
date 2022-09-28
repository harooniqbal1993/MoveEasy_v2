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
    
    let textColor: UIColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
    
    var feedbackViewModel: FeedbackViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViews()
    }
    
    func loadViews() {
        filterButton.forEach { button in
            button.border(color: .systemGray4, radius: 5, width: 2.0)
            button.addTarget(self, action: #selector(filterButtonTapped(_sender:)), for: .touchUpInside)
        }
        addCommentButton.border(color: Constants.themeColor, radius: 6, width: 1.0)
        commentTextView.border(color: textColor, radius: 0.0, width: 1.0)
        submitButton.round()
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
        feedbackViewModel?.submitFeedback(rating: 0, comments: commentTextView.text, userID: 0, completion: { [weak self] result, error in
            if let error = error {
                self?.showAlert(title: "Error", message: error)
                return
            }
        })
        navigationController?.popToRootViewController(animated: true)
    }
}
