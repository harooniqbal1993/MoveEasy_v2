//
//  BookingPropertyCell.swift
//  MoveEasy
//
//  Created by Haroon Iqbal on 01/05/2023.
//

import UIKit

class BookingPropertyCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(bookingPropertyModel: BookingPropertyModel) {
        icon.image = bookingPropertyModel.image
        propertyLabel.text = bookingPropertyModel.name
        valueLabel.text = bookingPropertyModel.value
    }

}
