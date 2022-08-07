//
//  HomeViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit
import FittedSheets

class HomeViewController: UIViewController {
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var upcomingOrderCountLabel: UILabel!
    @IBOutlet weak var completedOrderCountLabel: UILabel!
    @IBOutlet weak var viewAllOrderButton: UIButton!
    @IBOutlet weak var activeOrderLabel: UILabel!
    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var leftCardView: UIView!
    @IBOutlet weak var rightCardView: UIView!
    @IBOutlet weak var activeOrderView: UIView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var homeViewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadViews()
    }
    
    func configure() {
        homeViewModel = HomeViewModel()
        
        orderTable.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        filterCollectionView.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "FilterCell")
        
        getDashboardData()
    }
    
    private func loadViews() {
        profileImage.round()
        leftCardView.round(radius: 15.0)
        rightCardView.round(radius: 15.0)
        viewAllOrderButton.round()
        activeOrderView.round(radius: 15.0)
        leftCardView.backgroundImage(image: "green-card")
        rightCardView.backgroundImage(image: "purple-card")
        switchButton.isOn = Defaults.driverStatus ?? false
    }
    
    private func updateViews() {
        usernameLabel.text = "Hi, \(homeViewModel.driverName ?? "")"
        upcomingOrderCountLabel.text = "\(homeViewModel.upcomingOrders)"
//        completedOrderCountLabel.text  = "\(homeViewModel.completedOrder)"
        orderTable.reloadData()
    }
    
    private func getDashboardData() {
        homeViewModel.getDashboardData { error in
            DispatchQueue.main.async {
                if error != nil {
                    return
                }
                self.updateViews()
            }
        }
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
        self.revealViewController().revealToggle(self)
    }
    
    @IBAction func allOrderTapped(_ sender: UIButton) {
        let allOrderViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "AllOrderViewController") as! AllOrderViewController
        allOrderViewController.allOrders = homeViewModel.allOrders
        navigationController?.pushViewController(allOrderViewController, animated: true)
    }
    
    @IBAction func statusChanged(_ sender: UISwitch) {
        DriverSession.shared.setDriverStatus(status: sender.isOn)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.activeOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.configure(viewModel: OrderCellViewModel(order: homeViewModel.activeOrders[indexPath.row]))
        cell.completion = { [weak self] in
//            let proofViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ProofViewController") as! ProofViewController
//            self?.navigationController?.pushViewController(proofViewController, animated: true)
            
            let tripDetailViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailViewController
            let tripDetailViewModel = TripDetailViewModel(order: (self?.homeViewModel.activeOrders[indexPath.row])!)
            tripDetailViewController.tripDetailViewModel = tripDetailViewModel
            tripDetailViewController.onDismiss = { [weak self] in
                let tripDetailViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailViewController
                tripDetailViewController.isFullScreen = true
                tripDetailViewController.tripDetailViewModel = tripDetailViewModel
                self?.navigationController?.pushViewController(tripDetailViewController, animated: true)
            }
            let sheetController = SheetViewController(controller: tripDetailViewController, sizes:[.marginFromTop(150.0)], options: Constants.fittedSheetOptions)
            sheetController.cornerRadius = 0
            self?.present(sheetController, animated: true, completion: nil)

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        240
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.configure(viewModel: FilterCellViewModel(filterModel: homeViewModel.filterArray[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeViewModel.refreshFilters(selectedFilter: homeViewModel.filterArray[indexPath.row])
        filterCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = 100
        return CGSize(width: width, height: 60)
    }
}
