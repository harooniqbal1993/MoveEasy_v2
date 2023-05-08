//
//  TripDetailViewController.swift
//  MoveEasy
//
//  Created by Apple on 13/12/1443 AH.
//

import UIKit
import UIView_Shimmer
//import FittedSheets

extension UILabel: ShimmeringViewProtocol { }

class TripDetailViewController: UIViewController {

    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var viewMapButton: UIButton!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var moverCountLabel: UILabel!
    @IBOutlet weak var moveTypeLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var workTimeLabel: UILabel!
    @IBOutlet weak var moveSizeLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var pickAddressLabel: UILabel!
    @IBOutlet weak var pickAddressInstructionLabel: UILabel!
    @IBOutlet weak var dropAddressLabel: UILabel!
    @IBOutlet weak var dropAddressInstructionLabel: UILabel!
    @IBOutlet weak var acceptButton: SpinnerButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var startJobButton: SpinnerButton!
    @IBOutlet weak var connector: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bookingCollectionView: UICollectionView!
    
    var tripDetailViewModel: TripDetailViewModel!
    var isFullScreen: Bool = false
    var onDismiss: ((Bool) -> Void)?
    
    var shimmeringAnimatedItems: [UIView] {
        [
            orderNumberLabel,
            customerNameLabel
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadViews()
        configure()
        getOrderSummary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadViews()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        let tripDetailViewController =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailViewController
//        navigationController?.pushViewController(tripDetailViewController, animated: true)
//    }
    
    func configure() {
        bookingCollectionView.delegate = self
        bookingCollectionView.dataSource = self
        
        bookingCollectionView.register(UINib(nibName: "BookingPropertyCell", bundle: nil), forCellWithReuseIdentifier: "BookingPropertyCell")
        bookingCollectionView.register(UINib(nibName: "AddressCell", bundle: nil), forCellWithReuseIdentifier: "AddressCell")
        bookingCollectionView.register(UINib(nibName: "BookingPropertyFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "BookingPropertyFooterView")
        
    }
    
    func loadViews() {
        view.setTemplateWithSubviews(true, viewBackgroundColor: .systemBackground)
        viewMapButton.border(color: Constants.themeColor, width: 1.0)
        acceptButton.round()
        rejectButton.border(color: Constants.themeColor, width: 1.0)
        startJobButton.round()
        startJobButton.isHidden = true
        connector.makeDashedBorderLine(color: Constants.themeColor, strokeLength: 7, gapLength: 5, width: 1, orientation: .vertical)
        
        self.sheetViewController?.handleScrollView(scrollView)
        
        if isFullScreen {
            startJobButton.isHidden = false
            startJobButton.round()
            acceptButton.isHidden = true
            rejectButton.isHidden = true
        }
        updateViews()
    }
    
    func updateViews() {
        orderNumberLabel.text = "Order # \(tripDetailViewModel.orderNumber ?? 0)"
        customerNameLabel.text = tripDetailViewModel.customerName
        phoneLabel.text = tripDetailViewModel.phoneNumber
        dateLabel.text = tripDetailViewModel.date
        timeLabel.text = tripDetailViewModel.time
        vehicleTypeLabel.text = tripDetailViewModel.vehicleType
        moverCountLabel.text = tripDetailViewModel.numberOfMoovers
        moveTypeLabel.text = tripDetailViewModel.moveType
        jobTypeLabel.text = tripDetailViewModel.jobType
        workTimeLabel.text = workTimeLabel.text
        moveSizeLabel.text = tripDetailViewModel.moveSize
        incomeLabel.text = incomeLabel.text
        pickAddressLabel.text = tripDetailViewModel.pickupLocation
        incomeLabel.text = incomeLabel.text
        pickAddressInstructionLabel.text = tripDetailViewModel.pickupInstructions
        dropAddressLabel.text = tripDetailViewModel.dropoffLocation
        dropAddressInstructionLabel.text = tripDetailViewModel.dropoffInstructions
        viewMapButton.isHidden = tripDetailViewModel.mapButtonHidden
        if OrderSession.shared.bookingModel?.driverId == nil {
            startJobButton.isHidden = true
            rejectButton.isHidden = false
            acceptButton.isHidden = false
        } else {
            startJobButton.isHidden = false
            rejectButton.isHidden = true
            acceptButton.isHidden = true
        }
        
        self.view.setTemplateWithSubviews(false)
    }
    
    func getOrderSummary() {
        tripDetailViewModel?.getBooking(bookingID: "\(OrderSession.shared.order?.id ?? 0)", completion: { [weak self] error in
//        tripDetailViewModel?.getBooking(bookingID: "2269", completion: { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "Error", message: error)
                    return
                }

                self?.updateViews()
                self?.bookingCollectionView.reloadData()
            }
        })
    }
    
    func acceptOrder() {
        acceptButton.setTitle("")
        acceptButton.startLoading()
        tripDetailViewModel.acceptOrder { [weak self] error in
            DispatchQueue.main.async {
                self?.acceptButton.stopLoading()
                if let error = error {
                    self?.showAlert(title: "Booking", message: error)
                    return
                }
                
                self?.dismiss(animated: false) {
                    self?.onDismiss?(false)
                }
            }
        }
    }
    
    func cancelBooking() {
        tripDetailViewModel.cancelBooking { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "Booking", message: error)
                    return
                }
                
                self?.dismiss(animated: false)
            }
        }
    }
    
    @IBAction func viewMapTapped(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.onDismiss?(true)
        }
//        let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//        mapViewController.modalPresentationStyle = .fullScreen
//        present(mapViewController, animated: true)
    }
    
    @IBAction func acceptButtonTapped(_ sender: SpinnerButton) {
        acceptOrder()
//        self.dismiss(animated: false) {
//            self.onDismiss?(false)
//        }
    }
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        cancelBooking()
    }
    
    @IBAction func startJobTapped(_ sender: SpinnerButton) {
        startJobButton.setTitle("")
        startJobButton.startLoading()
        self.dismiss(animated: false) {
            self.onDismiss?(false)
        }
    }
}


extension TripDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? tripDetailViewModel.properties?.count ?? 0 : tripDetailViewModel.stops?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingPropertyCell", for: indexPath) as! BookingPropertyCell
            if let property = tripDetailViewModel.properties?[indexPath.item] {
    //            cell.contentView.backgroundColor = (indexPath.item % 2 == 0) ? .red : .blue
                cell.configure(bookingPropertyModel: property)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressCell", for: indexPath) as! AddressCell
            if let stop = tripDetailViewModel.stops?[indexPath.item] {
                cell.configure(stop: stop, stopCount: tripDetailViewModel.stops?.count ?? 0, index: indexPath.row)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(indexPath.section, collectionView.frame.width)
        return indexPath.section == 0 ? CGSize(width: (collectionView.frame.width - 20) / 2, height: 75) : CGSize(width: collectionView.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {return UICollectionReusableView()}
        switch kind {
            
//        case UICollectionView.elementKindSectionHeader:
//
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
//
//            headerView.backgroundColor = UIColor.blue
//            return headerView
        
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BookingPropertyFooterView", for: indexPath) as! BookingPropertyFooterView
            footerView.configure(bookingModel: OrderSession.shared.bookingModel)
            footerView.onStartJob = { [weak self] (startJobButton) in
                self?.dismiss(animated: false) {
                    self?.onDismiss?(false)
                    startJobButton.stopLoading()
                }
            }
            footerView.onAcceptJob = { [weak self] in
                self?.acceptOrder()
            }
            footerView.onRejectJob = { [weak self] in
                self?.cancelBooking()
            }
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let footerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: indexPath)
        return footerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}
