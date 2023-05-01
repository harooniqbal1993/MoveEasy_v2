//
//  FinishJobModel.swift
//  MoveEasy
//
//  Created by Apple on 31/10/2022.
//

import Foundation

struct FinishJobModel: Decodable {
    var bookingTotalModel: BookingTotalModel? = nil
    var stops: [Stop]? = nil
}

struct BookingTotalModel: Decodable {
    var coupon: String? = nil
    var discount: String? = nil
    var baseFare: String? = nil
    var totalDistance: String? = nil
    var gstandPst: String? = nil
    var subtotal: String? = nil
    var totalChargeBTax: String? = nil
    var transferFee: String? = nil
    var totalServiceFee: String? = nil
    var totalCharge: String? = nil
    var serviceFee: String? = nil
    var labourSurcharge: String? = nil
    var totalTaxGstpstrate: String? = nil
    var totalDuration: String? = nil
    var workTime: String? = nil
    var traveltime: String? = nil
    var hourlyRate: String? = nil
}

struct TimeResponse: Decodable {
    var statusCode: Int? = nil
    var message: String? = nil
    var data: TimeInterval? = 0
}

//struct Stop: Decodable {
//    var id: Int? = nil
//    var stop: String? = nil
//    var personName: String? = nil
//    var personPhone: String? = nil
//    var instructions: String? = nil
//    var bookingId: Int? = nil
//    var lat: String? = nil
//    var long: String? = nil
//}
