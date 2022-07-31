//
//  FeedBackViewController.swift
//  MoveEasy
//
//  Created by Apple on 13/12/1443 AH.
//

import UIKit

class FeedBackViewController: UIViewController {

    @IBOutlet weak var rudeButton: UIButton!
    @IBOutlet weak var aggressiveButton: UIButton!
    @IBOutlet weak var notReallyButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViews()
    }
    
    func loadViews() {
        rudeButton.border(color: .systemGray4, radius: 5, width: 2.0)
        aggressiveButton.border(color: .systemGray4, radius: 5, width: 2.0)
        notReallyButton.border(color: .systemGray4, radius: 5, width: 2.0)
        otherButton.border(color: .systemGray4, radius: 5, width: 2.0)
    }
}
