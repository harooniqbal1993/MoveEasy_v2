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
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var pickupInstructionLabel: UILabel!
    @IBOutlet weak var dropoffAddressLabel: UILabel!
    @IBOutlet weak var dropoffInstructionLabel: UILabel!
    
    var onStartJob: ((SpinnerButton) -> Void)?
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
    }
    
    func loadViews() {
        startJobButton.round()
        acceptButton.round()
        rejectButton.border(color: Constants.themeColor, width: 1.0)
        
        if OrderSession.shared.bookingModel?.driverId == nil {
            startJobButton.isHidden = true
            rejectButton.isHidden = false
            acceptButton.isHidden = false
        } else {
            startJobButton.isHidden = false
            rejectButton.isHidden = true
            acceptButton.isHidden = true
        }
    }
    
    @IBAction func startJobTapped(_ sender: SpinnerButton) {
        startJobButton.setTitle("")
        startJobButton.startLoading()
        self.onStartJob?(startJobButton)
    }
    
    @IBAction func acceptJobTapped(_ sender: SpinnerButton) {
        onAcceptJob?()
    }
    
    @IBAction func rejectJobTapped(_ sender: UIButton) {
        onRejectJob?()
    }
}
