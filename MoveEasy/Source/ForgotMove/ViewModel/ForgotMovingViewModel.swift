//
//  ForgotMovingViewModel.swift
//  MoveEasy
//
//  Created by Apple on 10/02/1444 AH.
//

import Foundation

class ForgotMovingViewModel {
    
    var isStartDateTapped = false
    var name: String? = nil
    var email: String? = nil
    var startTime: String? = nil
    var endTime: String? = nil
    
    func forgotTimer(completion: @escaping (_ error: String?) -> Void) {
        let forgotTimerRequest: ForgotTimerRequest = ForgotTimerRequest(id: 0, driverId: DriverSession.shared.driver?.id, name: name, email: email, startTime: startTime, endTime: endTime, bookingId: OrderSession.shared.bookingModel?.id, userId: OrderSession.shared.bookingModel?.userId, isApproved: true)
        NetworkService.shared.forgotTimer(forgotTimerRequest: forgotTimerRequest) { result, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
