//
//  BookingPropertyFooterView.swift
//  MoveEasy
//
//  Created by Haroon Iqbal on 01/05/2023.
//

import UIKit

class BookingPropertyFooterView: UICollectionReusableView {
    
    @IBOutlet weak var startJobButton: SpinnerButton!
    @IBOutlet weak var acceptButton: SpinnerButton!
    @IBOutlet weak var rejectButton: SpinnerButton!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var pickupInstructionLabel: UILabel!
    @IBOutlet weak var dropoffAddressLabel: UILabel!
    @IBOutlet weak var dropoffInstructionLabel: UILabel!
    
    var onStartJob: (() -> Void)?
    var onAcceptJob: (() -> Void)?
    var onRejectJob: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadViews()
    }
    
    func configure(bookingModel: OrderSummaryModel?) {
        pickupAddressLabel.text = bookingModel?.pickupLocation
        pickupInstructionLabel.text = bookingModel?.pickUpInstructions
        dropoffAddressLabel.text = bookingModel?.dropoffLocation
        dropoffInstructionLabel.text = bookingModel?.dropOffInstructions
        
        let toggleButton: Bool = (OrderSession.shared.bookingModel?.status == .COMPLETED || OrderSession.shared.bookingModel?.status == .ACTIVE)
        acceptButton.isHidden = toggleButton
        rejectButton.isHidden = toggleButton
        startJobButton.isHidden = !toggleButton
        startJobButton.setTitle(OrderSession.shared.bookingModel?.status == .COMPLETED ? "View Details" : "Start Job", for: .normal)
    }
    
    func loadViews() {
        startJobButton.round()
        acceptButton.round()
        rejectButton.border(color: Constants.themeColor, width: 1.0)
        startJobButton.setTitle(OrderSession.shared.bookingModel?.status == .COMPLETED ? "View Details" : "Start Job")
        
//        if OrderSession.shared.bookingModel?.driverId == nil {
//            startJobButton.isHidden = true
//            rejectButton.isHidden = false
//            acceptButton.isHidden = false
//        } else {
//            startJobButton.isHidden = false
//            rejectButton.isHidden = true
//            acceptButton.isHidden = true
//        }
        
    }
    
    @IBAction func startJobTapped(_ sender: SpinnerButton) {
        self.startJobButton.setTitle("")
        self.startJobButton.startLoading()
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.onStartJob?()
        }
    }
    
    @IBAction func acceptJobTapped(_ sender: SpinnerButton) {
        self.acceptButton.setTitle("")
        self.acceptButton.startLoading()
//        onAcceptJob?()
        acceptOrder()
    }
    
    @IBAction func rejectJobTapped(_ sender: SpinnerButton) {
        self.rejectButton.setTitle("")
        self.rejectButton.startLoading()
//        onRejectJob?()
        cancelBooking()
    }
    
    func acceptOrder() {
        NetworkService.shared.acceptBooking(bookingID: "\(OrderSession.shared.order?.id ?? 0)") { [weak self] (bookingModel, error) in
            DispatchQueue.main.async {
//                if let error = error {
//                    return
//                }
                self?.onAcceptJob?()
            }
        }
    }
    
    func cancelBooking() {
        NetworkService.shared.cancelBooking(bookingID: "\(OrderSession.shared.order?.id ?? 0)") { [weak self] (result, error) in
            DispatchQueue.main.async {
//                if let error = error {
//                    return
//                }
                self?.onRejectJob?()
            }
        }
    }
}
