//
//  RegisterViewModel.swift
//  MoveEasy
//
//  Created by Apple on 17/12/1443 AH.
//

import Foundation
import UIKit

class RegisterViewModel {
    
    var email: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var password: String? = nil
    var phone: String? = nil
    var isPolicy: Bool = false
    var driverId: Int? = 0
    var token: String? = nil
    
    func updatePolicy() {
        self.isPolicy = !self.isPolicy
    }
    
    func validate(email: String, firstName: String, lastName: String, password: String, phone: String, confirmPassword: String, completion: @escaping (Bool, String?) -> Void) {
        if email.isEmpty {
            completion(false, "Email field is required")
        }
        if !email.isValidEmail {
            completion(false, "Enter valid email")
        }
        if firstName.isEmpty {
            completion(false, "First name field is required")
        }
        if lastName.isEmpty {
            completion(false, "Last name field is required")
        }
        if password.isEmpty {
            completion(false, "Password is required")
        }
        if phone.isEmpty {
            completion(false, "Phone is required")
        }
        
        if confirmPassword.isEmpty {
            completion(false, "Confirm password is required")
        }
        
        if confirmPassword != password {
            completion(false, "Password didn't match")
        }
        
        let registerRequest = RegisterRequest(email: email, firstName: firstName, lastName: lastName, password: password, phone: phone)
        
        registerDriver(registerRequest: registerRequest) { status, error in
            if status == true {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func registerDriver(registerRequest: RegisterRequest, completion: @escaping (Bool, String?) -> Void) {
        NetworkService.shared.registerDriver(loginRequest: registerRequest) { [weak self] result, error  in
            DispatchQueue.main.async {
                if result?.statusCode == 201 {
                    Defaults.driverEmail = registerRequest.email
                    self?.driverId = result?.data?.id
                    self?.token = result?.token
                    completion(true, nil)
                } else {
                    completion(false, result?.message)
                }
            }
        }
    }
}
