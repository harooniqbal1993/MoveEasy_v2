//
//  ForgotTimer.swift
//  MoveEasy
//
//  Created by Nimra Jamil on 1/23/23.
//

import Foundation

struct ForgotTimerRequest: Codable {
    var id: Int? = nil
    var driverId: Int? = nil
    var name: String? = nil
    var email: String? = nil
    var startTime: String? = nil
    var endTime: String? = nil
    var bookingId: Int? = nil
    var userId: Int? = nil
    var isApproved: Bool = true
}

struct ForgotTimerResponse: Decodable {
    var statusCode: Int? = nil
    var message: String? = nil
    var data: ForgotTimerRequest? = nil
}

//{
//  "statusCode": 200,
//  "message": "Form added, couldn't send message",
//  "data": {
//    "id": 16,
//    "driverId": 1125,
//    "name": "haroon",
//    "email": "03359799769",
//    "startTime": "2023-01-31T16:44:58.807Z",
//    "endTime": "2023-01-31T16:44:58.807Z",
//    "notes": "some notes",
//    "bookingId": 1003,
//    "userId": 1001,
//    "isApproved": false
//  }
//}
