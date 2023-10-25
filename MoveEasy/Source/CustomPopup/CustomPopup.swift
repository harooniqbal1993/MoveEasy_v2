//
//  CustomPopup.swift
//  MoveEasy
//
//  Created by Haroon Iqbal on 18/10/2023.
//

import UIKit

class CustomPopup: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViews()
    }
    
    init() {
        super.init(nibName: "CustomPopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViews() {
        containerView.round(radius: 12.0)
        statusButton.rounded()
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false)
    }
    
    @IBAction func statusButtonTapped(_ sender: UIButton) {
        let url: String = "https://moversignup.moovez.ca/Driver/status/\(DriverSession.shared.driver?.id ?? 0)?token=\(Defaults.authToken ?? "")"
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
