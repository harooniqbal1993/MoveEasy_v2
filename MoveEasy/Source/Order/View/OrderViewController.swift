//
//  OrderViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit
import WebKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebview()
    }
    
    func configureWebview() {
//        webView.frame = view.bounds
//        webView.navigationDelegate = self
        
        let url = URL(string: "https://moversignup.moovez.ca/Driver/myEarningsDriv/\(DriverSession.shared.driver?.id ?? 1116)")!
        let urlRequest = URLRequest(url: url)
        
        webView.load(urlRequest)
//        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        view.addSubview(webView)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.revealViewController().revealToggle(self)
//        performSegue(withIdentifier: "home_segue", sender: nil)
        
    }
    
}
