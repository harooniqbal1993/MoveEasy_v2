//
//  AddressCell.swift
//  MoveEasy
//
//  Created by Haroon Iqbal on 04/05/2023.
//

import UIKit

class AddressCell: UICollectionViewCell {

    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var pickupInstructionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(stop: Stop, stopCount: Int, index: Int) {
        print("\(index) == \(stopCount - 1)")
        if OrderSession.shared.bookingModel?.type?.lowercased() == "Moovers".lowercased() {
            pickupLabel.text = "Address \(index + 1)"
        } else {
            if index > 0 && index < stopCount - 1 {
                pickupLabel.text = "Additional address"
            } else if index == stopCount - 1 {
                pickupLabel.text = "Dropoff address"
            } else {
                pickupLabel.text = "Pickup address"
            }
        }
        
        pickupAddressLabel.text = stop.stop
        pickupInstructionLabel.text = stop.instructions
    }

}
