//
//  AllOrderViewController.swift
//  MoveEasy
//
//  Created by Apple on 10/12/1443 AH.
//

import UIKit
import FittedSheets

class AllOrderViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var allOrderTable: UITableView!
    @IBOutlet weak var onlineSwitch: UISwitch!
    
    var allOrders: [OrderModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        loadViews()
    }
    
    func configure() {
        allOrderTable.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
    }
    
    func loadViews() {
        profileImage.round()
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
        self.revealViewController().revealToggle(self)
    }
    
    @IBAction func onlineStatusChanged(_ sender: UISwitch) {
    }
}

extension AllOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.configure(viewModel: OrderCellViewModel(order: allOrders[indexPath.row]))
        cell.completion = {
            let tripDetailViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailViewController
            tripDetailViewController.tripDetailViewModel = TripDetailViewModel(order: self.allOrders[indexPath.row])
            let sheetController = SheetViewController(controller: tripDetailViewController, sizes:[.marginFromTop(150.0)], options: Constants.fittedSheetOptions)
            sheetController.cornerRadius = 0
            self.present(sheetController, animated: true, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        240
    }
}
