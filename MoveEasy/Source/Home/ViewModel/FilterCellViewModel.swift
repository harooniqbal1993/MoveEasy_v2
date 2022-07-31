//
//  FilterCellViewModel.swift
//  MoveEasy
//
//  Created by Apple on 17/12/1443 AH.
//

import Foundation

class FilterCellViewModel {
    var filterModel: FilterModel? = nil
    
    var name: String {
        return filterModel?.name ?? ""
    }
    
    var isSelected: Bool {
        return filterModel?.isSelected ?? false
    }
    
    init(filterModel: FilterModel?) {
        self.filterModel = filterModel
    }
}
