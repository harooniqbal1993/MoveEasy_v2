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
    
    var pickupLocation: String? {
        return order?.pickupLocation
    }
    
    var dropoffLocation: String? {
        return order?.dropoffLocation
    }
    
    init(order: OrderModel) {
        self.order = order
    }
    
    func acceptOrder(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.acceptBooking(bookingID: "1310") { bookingModel, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
    }
}
