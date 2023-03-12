//
//  LoginResponse.swift
//  MoveEasy
//
//  Created by Apple on 17/12/1443 AH.
//

import Foundation

struct LoginResponse: Decodable {
    var data: DriverModel? = nil
    var token: String? = nil
    var statusCode: Int? = nil
    var message: String? = nil
}

struct DriverModel: Decodable {
    var id: Int? = nil
    var email: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var secondaryEmail: String? = nil
    var profileDisplayImageUrl: String? = nil
    var streetAddress: String? = nil
    var city: String? = nil
    var province: String? = nil
    var gender: String? = nil
    var country: String? = nil
    var birthDate: String? = nil
    var phone: String? = nil
    var status: String? = nil
    var mooverType: String? = nil
    var allDocsUploaded: Bool? = false
    var isApproved: Bool? = false
    var isVerified: Bool? = nil
    var averageRating: Int? = 0
    var completedBookingCount: Int? = 0
}

//{
//    "statusCode":200,
//    "message":"Success",
//    "data":{
//        "id":1133,
//        "email":"codak11495@3mkz.com",
//        "firstName":"Hamza",
//        "lastName":"Hamid",
//        "secondaryEmail":null,
//        "profileDisplayImageUrl":null,
//        "streetAddress":null,
//        "city":null,
//        "province":null,
//        "gender":null,
//        "country":null,
//        "birthDate":null,
//        "phone":"03214535667",
//        "status":"INACTIVE",
//        "mooverType":null,
//        "allDocsUploaded":false,
//        "isApproved":true,
//        "isVerified":true
//        
//    }}
