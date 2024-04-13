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
    var startTime: String? = nil
    var endTime: String? = nil
    var bookingId: Int? = nil
    var userId: Int? = nil
    var isApproved: Bool = true
    var FormType: String? = nil // Edit_Job_Summary, Forgot_To_Start_Timer
    var notes: String? = nil
    var totalDuration: String? = nil
    var breakTime: Float? = nil
}

//{
//  "id": 0,
//  "driverId": 0,
//  "name": "string",
//  "phoneNumber": "string",
//  "email": "string",
//  "startTime": "2024-04-08T10:48:22.032Z",
//  "endTime": "2024-04-08T10:48:22.032Z",
//  "notes": "string",
//  "bookingId": 0,
//  "userId": 0,
//  "isApproved": true,
//  "totalDuration": "string",
//  "breakTime": 0,
//  "formType": "string"
//}

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
