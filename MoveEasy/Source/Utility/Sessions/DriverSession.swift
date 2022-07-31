//
//  DriverSession.swift
//  MoveEasy
//
//  Created by Apple on 22/12/1443 AH.
//

import Foundation

class DriverSession {
    static let shared: DriverSession = DriverSession()
    var driver: DriverModel? = nil
    
    private init() {}
    
    func setDriverStatus(status: Bool) {
        NetworkService.shared.setDriverStatus(status: status) { result, error in
            DispatchQueue.main.async {
                if result?.statusCode == 200 {
                    Defaults.driverStatus = result?.data?.lowercased() == "ACTIVE".lowercased()
                }
            }
        }
    }
    
    private func clearSession() {
        driver = nil
    }
}
