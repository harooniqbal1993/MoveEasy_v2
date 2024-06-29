//
//  HomeModel.swift
//  MoveEasy
//
//  Created by Apple on 22/12/1443 AH.
//

import Foundation

enum OrderStatus: String, Codable {
    case ACTIVE = "ACTIVE" // If driver accepts the booking
    case Active = "Active"
    case INACTIVE = "INACTIVE" // driver status // should not be here
    case PENDING = "PENDING" // Booking placed from Customer end, But not accepted by Driver
    case CONFIRMATION = "CONFIRMATION"
    case INPROGRESS = "INPROGRESS" // Start moving
    case Inprogress = "Inprogress"
    case COMPLETED = "COMPLETED" // on finishMoving API
    case INCOMPLETED = "INCOMPLETED" // customer is creating
    case CANCELLED = "CANCELLED"
    case DELIVERY = "Delivery"
    case PAIRED = "PAIRED"
    
    func getBackgroundColor() -> UIColor? {
        switch self {
        case .PENDING:
            return UIColor(red: 246/255, green: 191/255, blue: 79/255, alpha: 1.0)
        case .ACTIVE, .Active, .Inprogress, .INPROGRESS:
            return UIColor(red: 111/255, green: 222/255, blue: 49/255, alpha: 1.0)
        case .CANCELLED:
            return UIColor(red: 255/255, green: 49/255, blue: 49/255, alpha: 1.0)
        case .COMPLETED, .DELIVERY:
            return UIColor(red: 50/255, green: 42/255, blue: 136/255, alpha: 1.0)
        default:
            return UIColor(red: 50/255, green: 42/255, blue: 136/255, alpha: 1.0)
        }
    }
}

struct HomeModel: Decodable {
    var statusCode: Int? = nil
    var message: String? = nil
    var data: HomeDataModel? = nil
}

struct HomeDataModel: Decodable {
    var driverName: String? = nil
    var totalOrders: Int? = nil
    var completeOrders: Int? = nil
    var active: [OrderModel]? = nil
    var pending: [OrderModel]? = nil
    var completed: [OrderModel]? = nil
    var cancelled: [OrderModel]? = nil
    var activeTrip: OrderModel? = nil
    var today: [OrderModel]? = nil
    var myOrders: [OrderModel]? = nil
    var newOrders: [OrderModel]? = nil
    var scheduledOrders: [OrderModel]? = nil
}

struct OrderModel: Decodable {
    var id: Int? = nil
    var type: String? = nil
//    var status: String? = nil
    var status: OrderStatus? = nil
    var pickupLocation: String? = nil
    var dropoffLocation: String? = nil
    var orderTime: String? = nil
    var orderDate: String? = nil
    var stops: Int? = nil
    var riderName: String? = nil
    var riderPhone: String? = nil
    var createdDate: String? = nil
    var createdTime: String? = nil
    var isDeliverNow: Bool? = false
}

struct DriverStatusModel: Decodable {
    var statusCode: Int? = nil
    var message: String? = nil
    var data: String? = nil
}
