//
//  LoginViewModel.swift
//  MoveEasy
//
//  Created by Apple on 17/12/1443 AH.
//

import Foundation

class LoginViewModel {
    var loginRequest: LoginRequest! = LoginRequest()
    
    var email: String {
        return loginRequest.email ?? ""
    }
    
    var password: String {
        return loginRequest.password ?? ""
    }
    
    var rememberMe: Bool = true
    
    func updateRemeberMe() {
        self.rememberMe = !self.rememberMe
    }
    
    func validate(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        
        if email.isEmpty {
            completion(false, "Email field is required")
        }
        if !email.isValidEmail {
            completion(false, "Please enter valid email")
        }
        if password.isEmpty {
            completion(false, "Password is required")
        }
        loginRequest = LoginRequest(email: email, password: password, rememberMe: true)
        authenticate(loginRequest: loginRequest) { status, error  in
            completion(status, error)
        }
    }
    
    func authenticate(loginRequest: LoginRequest, completion: @escaping (Bool, String?) -> Void) {
        NetworkService.shared.loginDriver(loginRequest: loginRequest) { result, error  in
            DispatchQueue.main.async {
                Defaults.isLoggedIn = true
                Defaults.authToken = result?.token
                Defaults.driverStatus = result?.data?.status?.lowercased() == "ACTIVE".lowercased()
                Defaults.driverEmail = result?.data?.email
                DriverSession.shared.driver = result?.data
                if result?.token != nil {
                    self.sendDeviceToken()
                    completion(true, nil)
                } else {
                    completion(false, result?.message)
                }
            }
        }
    }
    
    func sendDeviceToken() {
        NetworkService.shared.sendDeviceToken(driverID: DriverSession.shared.driver?.id ?? 0, deviceToken: Defaults.deviceToken ?? "") { result, error in
            DispatchQueue.main.async {
                print("")
            }
        }
    }
}
