//
//  FinishJobModel.swift
//  MoveEasy
//
//  Created by Apple on 31/10/2022.
//

import Foundation

struct FinishJobModel: Decodable {
    var bookingTotalModel: BookingTotalModel? = nil
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
}
