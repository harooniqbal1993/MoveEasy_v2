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
        return OrderSession.shared.bookingModel?.pickUpPersonName // order?.riderName ?? ""
    }
    
    var phoneNumber: String? {
        return OrderSession.shared.bookingModel?.pickUpPersonPhone // order?.riderPhone
    }
    
    var date: String? {
        return OrderSession.shared.bookingModel?.deliveryDate
    }
    
    var time: String? {
        return OrderSession.shared.bookingModel?.exactTime
    }
    
    var pickupLocation: String? {
        return order?.pickupLocation
    }
    
    var dropoffLocation: String? {
        return order?.dropoffLocation
    }
    
    var pickupInstructions: String? {
        return OrderSession.shared.bookingModel?.pickUpInstructions
    }
    
    var dropoffInstructions: String? {
        return OrderSession.shared.bookingModel?.dropOffInstructions
    }
    
    var moveType: String? {
        return moveType(id: OrderSession.shared.bookingModel?.moveTypeId ?? 0)
    }
    
    var moveSize: String? {
        return moveSize(id: OrderSession.shared.bookingModel?.moveSizeId ?? 0)
    }
    
    var jobType: String? {
        return OrderSession.shared.bookingModel?.type
    }
    
    var vehicleType: String? {
        return vehicleType(id: OrderSession.shared.bookingModel?.vehicleTypeId ?? 0) // "\(OrderSession.shared.bookingModel?.vehicleTypeId ?? 0)"
    }
    
    var numberOfMoovers: String? {
        return "\(OrderSession.shared.bookingModel?.labourNeeded ?? 0)"
    }
    
    var mapButtonHidden: Bool {
        return (OrderSession.shared.bookingModel?.pickupLatitude == nil && OrderSession.shared.bookingModel?.pickupLongitude == nil && OrderSession.shared.bookingModel?.dropoffLatitude == nil && OrderSession.shared.bookingModel?.dropoffLongitude == nil)
    }
    
    init(order: OrderModel) {
        self.order = order
    }
    
    func getBooking(bookingID: String?, completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.getBookingSummary(bookingID: bookingID ?? "") { result, error in
            if let error = error {
                completion(error)
                return
            }
            OrderSession.shared.bookingModel = result
            
            completion(nil)
        }
    }
    
    func acceptOrder(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.acceptBooking(bookingID: "\(OrderSession.shared.order?.id ?? 0)") { bookingModel, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
    }
    
    func cancelBooking(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.cancelBooking(bookingID: "\(OrderSession.shared.order?.id ?? 0)") { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
    }
    
    func vehicleType(id: Int) -> String {
        switch id {
        case 1001:
            return "Mini Van"
        case 1002:
            return "Pickup Truck"
        case 1003:
            return "Cargo Van"
        case 1004:
            return "Trailer (4''x8'')"
        default:
            return "Trailer (5''x10'')"
        }
    }
    
    func moveType(id: Int) -> String {
        switch id {
        case 1000:
            return "2-3"
        case 1001:
            return "3-4"
        case 1003:
            return "4-5"
        case 1004:
            return "5-6"
        default:
            return "1"
        }
    }
    
    func moveSize(id: Int) -> String {
        switch id {
        case 1:
            return "1 Bedroom"
        case 2:
            return "2 Bedroom"
        case 3:
            return "3 Bedroom"
        case 4:
            return "4 Bedroom"
        case 5:
            return "5 Bedroom"
        case 6:
            return "6 Bedroom"
        default:
            return "Other"
        }
    }
}
