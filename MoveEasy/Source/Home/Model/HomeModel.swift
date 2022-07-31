//
//  HomeModel.swift
//  MoveEasy
//
//  Created by Apple on 22/12/1443 AH.
//

import Foundation

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
}

struct OrderModel: Decodable {
    var id: Int? = nil
    var type: String? = nil
    var status: String? = nil
    var pickupLocation: String? = nil
    var dropoffLocation: String? = nil
    var orderTime: String? = nil
    var orderDate: String? = nil
    var stops: Int? = nil
    var riderName: String? = nil
    var riderPhone: String? = nil
}

struct DriverStatusModel: Decodable {
    var statusCode: Int? = nil
    var message: String? = nil
    var data: String? = nil
}
