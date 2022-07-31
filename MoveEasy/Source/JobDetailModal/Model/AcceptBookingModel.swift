//
//  AcceptBookingModel.swift
//  MoveEasy
//
//  Created by Apple on 23/12/1443 AH.
//

import Foundation

struct AcceptBookingModel: Decodable {
    var statusCode: Int? = nil
    var message: String? = nil
    var data: BookingModel? = nil
}

struct BookingModel: Decodable {
    var id: Int? = nil
    var driverId: Int? = nil
    var bookingId: Int? = nil
    var assignedAt: String? = nil
    var score: String? = nil
    var priority: String? = nil
    var acceptedAt: String? = nil
    var arrivedAt: String? = nil
    var startedAt: String? = nil
    var finishedAt: String? = nil
    var loadingStartedAt: String? = nil
    var loadingFinshedAt: String? = nil
    var status: String? = nil
    var cancelledAt: String? = nil
    var notes: String? = nil
}
