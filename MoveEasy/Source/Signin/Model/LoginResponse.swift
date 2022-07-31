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
}
