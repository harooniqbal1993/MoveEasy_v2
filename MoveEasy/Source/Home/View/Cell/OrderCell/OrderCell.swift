//
//  OrderCell.swift
//  MoveEasy
//
//  Created by Apple on 10/12/1443 AH.
//

import UIKit
import UIView_Shimmer

class OrderCell: UITableViewCell, ShimmeringViewProtocol {

    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var dropoffAddressLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var mooverLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreDetailButton: UIButton!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var upperView: UIView!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            upperView,
            greenView
        ]
    }
    
    var completion: (() -> Void)?
    var orderViewModel: OrderCellViewModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadViews()
    }
    
    func loadViews() {
        statusLabel.round()
        moreDetailButton.round()
        greenView.round(radius: 20.0)
        upperView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }
    
    func configure(viewModel: OrderCellViewModel?) {
        self.orderViewModel = viewModel
        
        orderTypeLabel.text = orderViewModel?.type
        statusLabel.text = orderViewModel?.status
        pickupAddressLabel.text = orderViewModel?.pickupLocation
        dropoffAddressLabel.text = orderViewModel?.dropOffLocation
        photo.image = UIImage(named: orderViewModel?.icon ?? "empty-box")
        dateLabel.text = orderViewModel?.date
        timeLabel.text = orderViewModel?.time
        greenView.backgroundColor = orderViewModel?.typeColor
    }
    
    @IBAction func moreDetailTapped(_ sender: UIButton) {
        completion?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
