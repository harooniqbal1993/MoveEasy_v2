//
//  FilterCell.swift
//  MoveEasy
//
//  Created by Apple on 16/12/1443 AH.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    
    var filterCellViewModel: FilterCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadViews()
    }
    
    func loadViews() {
        containerView.border(color: .systemGray4, radius: 5.0, width: 1.0)
    }
    
    func configure(viewModel: FilterCellViewModel) {
        self.filterCellViewModel = viewModel
        filterLabel.text = filterCellViewModel?.name
        if filterCellViewModel?.isSelected ?? false {
            containerView.backgroundColor = Constants.themeColor
            filterLabel.textColor = .white
        } else {
            containerView.backgroundColor = .white
            filterLabel.textColor = UIColor(red: 180/255, green: 176/255, blue: 209/255, alpha: 1.0)
        }
    }
}
