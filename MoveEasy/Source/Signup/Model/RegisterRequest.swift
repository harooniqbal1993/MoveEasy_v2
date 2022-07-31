//
//  RegisterRequest.swift
//  MoveEasy
//
//  Created by Apple on 17/12/1443 AH.
//

import Foundation

struct RegisterRequest: Encodable {
    var email: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var password: String? = nil
    var phone: String? = nil
}
