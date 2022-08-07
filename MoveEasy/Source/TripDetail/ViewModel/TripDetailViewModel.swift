//
//  TripDetailViewModel.swift
//  MoveEasy
//
//  Created by Apple on 06/01/1444 AH.
//

import Foundation

class TripDetailViewModel {
    
    var order: OrderModel?
    
    var orderNumber: Int? {
        return order?.id ?? 0
    }
    
    var customerName: String? {
        return order?.riderName ?? ""
    }
    
    var phoneNumber: String? {
        return order?.riderPhone
    }
    
    var date: String? {
        return order?.orderDate
    }
    
    var time: String? {
        return order?.orderTime
    }
    
    init(order: OrderModel) {
        self.order = order
    }
}
