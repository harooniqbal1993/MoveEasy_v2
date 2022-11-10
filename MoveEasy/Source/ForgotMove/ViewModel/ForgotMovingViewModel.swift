//
//  ForgotMovingViewModel.swift
//  MoveEasy
//
//  Created by Apple on 10/02/1444 AH.
//

import Foundation

class ForgotMovingViewModel {
    
    var isStartDateTapped = false
    
    func forgotTimer(bookingID: Int, startTime: String, endTime: String, completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.forgotTimer(bookingID: bookingID, startTime: startTime, endTime: endTime) { result, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
