//
//  ManageJobViewModel.swift
//  MoveEasy
//
//  Created by Apple on 09/01/1444 AH.
//

import Foundation

class ManageJobViewModel {
    
    var receipt: BookingTotalModel? = nil
    var stops: [Stop]? = OrderSession.shared.bookingModel?.stops
    var stopCounter: Int = 0
    var isLastDestination: Bool = false
    
    func startMoving(bookingID: String) {
        NetworkService.shared.startMoving(bookingID: bookingID) { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    return
                }
            }
        }
    }
    
    func pauseMoving(bookingID: String) {
        NetworkService.shared.pauseMoving(bookingID: bookingID) { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    return
                }
            }
        }
    }
    
    func stopMoving(bookingID: String, completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.finishMoving(bookingID: bookingID) { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(error)
                    return
                }
                
                if let result = result {
                    self.receipt = result.bookingTotalModel
                }
                completion(nil)
            }
        }
    }
}
