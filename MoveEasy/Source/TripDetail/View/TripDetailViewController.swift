//
//  TripDetailViewController.swift
//  MoveEasy
//
//  Created by Apple on 13/12/1443 AH.
//

import UIKit
//import FittedSheets

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
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var startJobButton: UIButton!
    @IBOutlet weak var connector: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var tripDetailViewModel: TripDetailViewModel!
    var isFullScreen: Bool = false
    var onDismiss: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        let tripDetailViewController =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailViewController
//        navigationController?.pushViewController(tripDetailViewController, animated: true)
//    }
    
    func loadViews() {
        viewMapButton.border(color: Constants.themeColor, width: 1.0)
        acceptButton.round()
        rejectButton.border(color: Constants.themeColor, width: 1.0)
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
        orderNumberLabel.text = "\(tripDetailViewModel.orderNumber ?? 0)"
        customerNameLabel.text = tripDetailViewModel.customerName
        phoneLabel.text = tripDetailViewModel.phoneNumber
        dateLabel.text = tripDetailViewModel.date
        timeLabel.text = tripDetailViewModel.time
        vehicleTypeLabel.text = vehicleTypeLabel.text
        moverCountLabel.text = moverCountLabel.text
        moveTypeLabel.text = moveTypeLabel.text
        jobTypeLabel.text = jobTypeLabel.text
        workTimeLabel.text = workTimeLabel.text
        moveSizeLabel.text = moveSizeLabel.text
        incomeLabel.text = incomeLabel.text
        pickAddressLabel.text = tripDetailViewModel.pickupLocation
        incomeLabel.text = incomeLabel.text
        pickAddressInstructionLabel.text = pickAddressInstructionLabel.text
        dropAddressLabel.text = tripDetailViewModel.dropoffLocation
        dropAddressInstructionLabel.text = dropAddressInstructionLabel.text
    }
    
    func acceptOrder() {
        tripDetailViewModel.acceptOrder { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Booking", message: error)
                return
            }
            
            self?.dismiss(animated: false) {
                self?.onDismiss?(false)
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
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        acceptOrder()
//        self.dismiss(animated: false) {
//            self.onDismiss?(false)
//        }
    }
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func startJobTapped(_ sender: UIButton) {

        let proofViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ProofViewController") as! ProofViewController
        self.navigationController?.pushViewController(proofViewController, animated: true)
    }
}
