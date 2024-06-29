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
    
    var onStartJob: ((Bool?) -> Void)?
    var onAcceptJob: (() -> Void)?
    var onRejectJob: (() -> Void)?
    
    var isBlockJob: Bool? = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadViews()
    }
    
    func configure(bookingModel: OrderSummaryModel?) {
        pickupAddressLabel.text = bookingModel?.pickupLocation
        pickupInstructionLabel.text = bookingModel?.pickUpInstructions
        dropoffAddressLabel.text = bookingModel?.dropoffLocation
        dropoffInstructionLabel.text = bookingModel?.dropOffInstructions
        
        let toggleButton: Bool = (OrderSession.shared.bookingModel?.status == .COMPLETED || OrderSession.shared.bookingModel?.status == .ACTIVE || OrderSession.shared.bookingModel?.status == .PAIRED)
        acceptButton.isHidden = toggleButton
        rejectButton.isHidden = toggleButton
        startJobButton.isHidden = !toggleButton
        
        if OrderSession.shared.bookingModel?.isDeliverNow == true || OrderSession.shared.bookingModel?.status == .COMPLETED || OrderSession.shared.bookingModel?.status == .ACTIVE || OrderSession.shared.bookingModel?.status == .PAIRED {
            startJobButton.isHidden = false
            rejectButton.isHidden = true
            acceptButton.isHidden = true
        } else {
            startJobButton.isHidden = true
            rejectButton.isHidden = false
            acceptButton.isHidden = false
        }
        
        startJobButton.setTitle(OrderSession.shared.bookingModel?.status == .COMPLETED ? "View Details" : "Start Job", for: .normal)
        if OrderSession.shared.bookingModel?.status == .DELIVERY && OrderSession.shared.bookingModel?.isDeliverNow == true {
            startJobButton.setTitle("Start Job", for: .normal)
        }
        
//        startJobButton.setTitleColor(.gray, for: .disabled)
//        startJobButton.setTitleColor(Constants.themeColor, for: .normal)
    }
    
    func loadViews() {
        startJobButton.round()
        acceptButton.round()
        rejectButton.border(color: Constants.themeColor, width: 1.0)
        startJobButton.setTitle(OrderSession.shared.bookingModel?.status == .COMPLETED ? "View Details" : "Start Job")
        
        if OrderSession.shared.bookingModel?.isDeliverNow == false {
            if isDatePassed() == false {
                isBlockJob = true
//                startJobButton.isEnabled = false
            } else {
                isBlockJob = false
//                startJobButton.isEnabled = true
            }
        }
        
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
    
    private func isDatePassed() -> Bool {
        let currentDate = Date()
        if let targetDate = OrderSession.shared.bookingModel?.deliveryDate?.toDate() {
            if currentDate.compare(targetDate) == .orderedDescending {
                print("Current date is greater than the target date.")
                return true
            } else if currentDate.compare(targetDate) == .orderedAscending {
                print("Current date is less than the target date.")
                return false
            } else {
                print("Current date is equal to the target date.")
                return true
            }
        }
        return false
    }
    
    @IBAction func startJobTapped(_ sender: SpinnerButton) {
        self.startJobButton.setTitle("")
        self.startJobButton.startLoading()
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.onStartJob?(self.isBlockJob)
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
