//
//  LoginRequest.swift
//  MoveEasy
//
//  Created by Apple on 17/12/1443 AH.
//

import Foundation

struct LoginRequest: Encodable {
    var email: String? = nil
    var password: String? = nil
    var rememberMe: Bool = true
    
    init() {
        
    }
    
    init(email: String, password: String, rememberMe: Bool = true) {
        self.email = email
        self.password = password
        self.rememberMe = rememberMe
    }
}

struct DeviceIDRequest: Encodable {
    var id: Int? = nil
    var devicetoken: String? = nil
}
