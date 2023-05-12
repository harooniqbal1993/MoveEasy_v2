//
//  HomeViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit
import FittedSheets
import SDWebImage

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
    
    let refreshControl = UIRefreshControl()
    
    var homeViewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        registerNotificationCenter()
        loadViews()
        
        fromBackgroundPushNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNotificationCenter()
    }
    
    func configure() {
        
        homeViewModel = HomeViewModel()
//        registerNotificationCenter()
        
        orderTable.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        filterCollectionView.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "FilterCell")
        
//        getDashboardData()
        getDriverDetail()
        
        refreshControl.addTarget(self, action: #selector(onRefreshTable), for: .valueChanged)
        orderTable.addSubview(refreshControl)
    }
    
    func registerNotificationCenter() {
        NotificationCenter.default
            .addObserver(self,
                         selector:#selector(openTripView(_:)),
                         name: Constants.NotificationObserver.OPEN_TRIPVIEW.value, object: nil)
        
        NotificationCenter.default
            .addObserver(self,
                         selector:#selector(openReceiptView(_:)),
                         name: Constants.NotificationObserver.OPEN_RECEIPT_VIEW.value, object: nil)
    }
    
    func fromBackgroundPushNotification() {
        if Defaults.forgotTimerResponse != nil {
            DispatchQueue.main.async {
                if Defaults.forgotTimerResponse == 1 {
                    let welldoneViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "WelldoneViewController") as! WelldoneViewController
                    self.navigationController?.pushViewController(welldoneViewController, animated: true)
                } else {
                    let oopsViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "OopsViewController") as! OopsViewController
                    self.navigationController?.pushViewController(oopsViewController, animated: true)
                }
            }
            Defaults.forgotTimerResponse = nil
            return
        }
        
        if Defaults.fromBackgroundNotificationBookingID != nil {
            openTripDetailVC(bookingID: Defaults.fromBackgroundNotificationBookingID ?? "0")
        }
    }
    
    @objc func openReceiptView(_ notification: Notification) {
        DispatchQueue.main.async {
            if let response = notification.userInfo?["response"] as? Int {
                if response == 1 {
                    let signatureViewController = Constants.kJob.instantiateViewController(withIdentifier: "WelldoneViewController") as! WelldoneViewController
                    self.navigationController?.pushViewController(signatureViewController, animated: true)
                } else {
                    let signatureViewController = Constants.kJob.instantiateViewController(withIdentifier: "OopsViewController") as! OopsViewController
                    self.navigationController?.pushViewController(signatureViewController, animated: true)
                }
            }
            Defaults.forgotTimerResponse = nil
        }
    }
    
    func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: Constants.NotificationObserver.OPEN_TRIPVIEW.value, object: nil)
        NotificationCenter.default.removeObserver(self, name: Constants.NotificationObserver.OPEN_RECEIPT_VIEW.value, object: nil)
    }
    
    private func loadViews() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.items?[0].isEnabled = false
        self.tabBarController?.tabBar.items?[2].isEnabled = false
        self.orderTable.separatorStyle = .none
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
        completedOrderCountLabel.text  = "\(homeViewModel.completedOrder)"
        if let activeTrip = homeViewModel.activeTrip {
            activeOrderLabel.text = "Order# \(activeTrip.id ?? 0)"
            viewAllOrderButton.isHidden = false
        } else {
            activeOrderLabel.text = "No active order"
            viewAllOrderButton.isHidden = true
        }
//        if let dp = DriverSession.shared.driver?.profileDisplayImageUrl {
        profileImage.sd_setImage(with: URL(string: DriverSession.shared.driver?.profileDisplayImageUrl ?? ""), placeholderImage: UIImage(named: "user"))
//        }
        
        orderTable.reloadData()
    }
    
    private func getDashboardData() {
        homeViewModel.getDashboardData { error in
            DispatchQueue.main.async {
                if error != nil {
                    if ((error?.contains("expired")) != nil) {
//                        self.logout()
                        return
                    }
                    self.showAlert(title: "Error", message: error ?? "Some Error")
                    return
                }
                self.updateViews()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func getDriverDetail() {
        homeViewModel.getDriverDetail { [weak self] in
            DispatchQueue.main.async {
                self?.usernameLabel.text = DriverSession.shared.driver?.firstName
                if DriverSession.shared.driver?.status == "INACTIVE" {
                    let goOnlineViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoOnlineViewController") as! GoOnlineViewController
//                    goOnlineViewController.modalPresentationStyle = .fullScreen
//                    self?.present(goOnlineViewController, animated: false)
                    self?.navigationController?.pushViewController(goOnlineViewController, animated: false)
                    
//                    let goOnlineViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoOnlineViewController") as! GoOnlineViewController
//                    goOnlineViewController.modalPresentationStyle = .fullScreen
//                    let navController = UINavigationController(rootViewController: goOnlineViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
//                    self?.present(navController, animated:true, completion: nil)
                }
                self?.getDashboardData()
            }
        }
    }
    
    private func getTodaysBookings() {
        homeViewModel.getTodaysBookings { error in
            DispatchQueue.main.async {
                if error != nil {
                    self.showAlert(title: "Error", message: error ?? "Some Error")
//                    return
                }
                self.updateViews()
            }
        }
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
        self.revealViewController().revealToggle(self)
//        self.revealViewController().panGestureRecognizer()
        self.revealViewController().tapGestureRecognizer()
    }
    
    @IBAction func allOrderTapped(_ sender: UIButton) {
        openTripDetailVC(bookingID: "\(homeViewModel.activeTrip?.id ?? 0)")
        
//        return
//        let allOrderViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "AllOrderViewController") as! AllOrderViewController
//        allOrderViewController.allOrders = homeViewModel.allOrders
//        navigationController?.pushViewController(allOrderViewController, animated: true)
    }
    
    @IBAction func statusChanged(_ sender: UISwitch) {
        if sender.isOn == false {
            let goOnlineViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoOnlineViewController") as! GoOnlineViewController
            self.navigationController?.pushViewController(goOnlineViewController, animated: false)
        }
        DriverSession.shared.setDriverStatus(status: Defaults.driverStatus == true ? false : true)
    }
    
    @objc func onRefreshTable(refreshControl: UIRefreshControl) {
        getDashboardData()
    }
    
    @objc func openTripView(_ notification: Notification) {
        
        if let dict = notification.userInfo?["bookingID"] as? String {
//            if let bookingID = dict["bookingID"] as? String {
//                openTripDetailVC(bookingID: bookingID)
//            }
            openTripDetailVC(bookingID: dict)
        }
    }
    
    func openTripDetailVC(bookingID: String) {
        DispatchQueue.main.async {
            let tripDetailViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailViewController
            let order = OrderModel(id: Int(bookingID ), type: "Mooving", status: "In Progress", pickupLocation: "Lahore", dropoffLocation: "Islamabad", orderTime: "10:23:44", orderDate: "12/12/2022", stops: 1, riderName: nil, riderPhone: nil)
            OrderSession.shared.order = order
            let tripDetailViewModel = TripDetailViewModel(order: order)
            tripDetailViewController.tripDetailViewModel = tripDetailViewModel
            tripDetailViewController.onDismiss = { [weak self] isMap in
                if !isMap {
                    let manageJobViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ManageJobViewController") as! ManageJobViewController
                    manageJobViewController.manageJobViewModel = ManageJobViewModel()
                    OrderSession.shared.order = order
                    self?.navigationController?.pushViewController(manageJobViewController, animated: true)
                } else {
                    let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                    mapViewController.modalPresentationStyle = .fullScreen
                    mapViewController.onAccept = { [weak self] in
                        let manageJobViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ManageJobViewController") as! ManageJobViewController
                        manageJobViewController.manageJobViewModel = ManageJobViewModel()
                        OrderSession.shared.order = order
                        self?.navigationController?.pushViewController(manageJobViewController, animated: true)
                    }
                    self?.present(mapViewController, animated: true)
                }
            }
            let sheetController = SheetViewController(controller: tripDetailViewController, sizes:[.marginFromTop(150.0)], options: Constants.fittedSheetOptions)
            sheetController.cornerRadius = 0
            self.present(sheetController, animated: true, completion: nil)
            Defaults.fromBackgroundNotificationBookingID = nil
        }
    }
    
    func logout() {
        let loginViewController: LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: loginViewController)
//        UIApplication.shared.keyWindow?.rootViewController = nav
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
//        let rootVC = window?.rootViewController
        window?.rootViewController = nav
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !homeViewModel.isLoading {
            if homeViewModel.displayedOrders?.count == 0 {
                tableView.setEmptyMessage("No bookings found")
            } else {
                tableView.restore()
            }
            return (homeViewModel.displayedOrders?.count ?? 0)
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if homeViewModel.isLoading  == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
            cell.setTemplateWithSubviews(homeViewModel.isLoading, viewBackgroundColor: .systemBackground)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.setTemplateWithSubviews(homeViewModel.isLoading, viewBackgroundColor: .systemBackground)
        if homeViewModel.isLoading == true { return cell }
        cell.configure(viewModel: OrderCellViewModel(order: homeViewModel.displayedOrders?[indexPath.row]))
        cell.completion = { [weak self] in
            self?.openTripDetailVC(bookingID: "\(self?.homeViewModel.displayedOrders?[indexPath.row].id ?? 0)")
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
        homeViewModel.filterOrders()
        orderTable.reloadData()
        filterCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = 100
        return CGSize(width: width, height: 60)
    }
}
