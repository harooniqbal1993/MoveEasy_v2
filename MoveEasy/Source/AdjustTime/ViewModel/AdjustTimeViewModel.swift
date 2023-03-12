//
//  AdjustTimeViewModel.swift
//  MoveEasy
//
//  Created by Nimra Jamil on 3/2/23.
//

import Foundation

class AdjustTimeViewModel {
    
    var actualTime: Int = Int(OrderSession.shared.bookingModel?.completionTime ?? 0) // 20
    var time: Int = Int(OrderSession.shared.bookingModel?.completionTime ?? 0)
    
    func decreaseTime() {
        time = time > 0 ? time - 1 : 0
    }
    
    func increaseTime() {
        time = time < actualTime ? time + 1 : time
    }
    
    func adjustTime(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.decreaseTimer(driverID: DriverSession.shared.driver?.id ?? 1125, bookingId: "\(OrderSession.shared.bookingModel?.id ?? 0)", seconds: time) { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(error)
                    return
                }
                
                if let result = result {
                }
                completion(nil)
            }
        }
    }
}
