//
//  OrderCellViewModel.swift
//  MoveEasy
//
//  Created by Apple on 23/12/1443 AH.
//

import Foundation

class OrderCellViewModel {
    
    var order: OrderModel? = nil
    
    var type: String {
        return order?.type ?? ""
    }
    
    var status: String {
        return order?.status ?? ""
    }
    
    var icon: String {
        return order?.type?.lowercased() == "Delivery".lowercased() ? "empty-box" : "booking-truck"
    }
    
    var pickupLocation: String {
        return order?.pickupLocation ?? ""
    }
    
    var dropOffLocation: String {
        return order?.dropoffLocation ?? ""
    }
    
//    var date: String {
//        let dateParts = order?.orderDate?.components(separatedBy: "-")
//        guard let date = dateParts?[0] else { return ""}
//        return getFormattedDate(rawDate: date, formatter: "dd MMM yyyy") ?? "" // order?.orderDate ?? ""
//    }
//
//    var time: String {
//        let dateParts = order?.orderDate?.components(separatedBy: "-")
//        guard let timePart = dateParts?[1] else { return ""}
//        return timePart
//    }
    
    var date: String {
        return order?.orderDate ?? ""
    }
    
    var time: String {
        return order?.orderTime ?? ""
    }
    
    var typeColor: UIColor {
        switch order?.type {
        case "Delivery":
            return UIColor(red: 104/255, green: 229/255, blue: 47/255, alpha: 1.0)
        case "Moovers":
            return UIColor(red: 212/255, green: 207/255, blue: 255/255, alpha: 1.0)
        default:
            return UIColor(red: 51/255, green: 42/255, blue: 136/255, alpha: 1.0)
        }
    }
    
    init(order: OrderModel?) {
        self.order = order
    }
}
