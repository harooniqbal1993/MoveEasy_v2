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
    
    init() {
        let pickupLocation = Stop(id: nil, stop: OrderSession.shared.bookingModel?.pickupLocation, personName: OrderSession.shared.bookingModel?.user?.firstName, personPhone: OrderSession.shared.bookingModel?.user?.phone, instructions: OrderSession.shared.bookingModel?.pickUpInstructions, bookingId: OrderSession.shared.bookingModel?.id, lat: OrderSession.shared.bookingModel?.pickupLatitude, long: OrderSession.shared.bookingModel?.pickupLongitude)
        
        let destinationLocation = Stop(id: nil, stop: OrderSession.shared.bookingModel?.dropoffLocation, personName: OrderSession.shared.bookingModel?.user?.firstName, personPhone: OrderSession.shared.bookingModel?.user?.phone, instructions: OrderSession.shared.bookingModel?.dropOffInstructions, bookingId: OrderSession.shared.bookingModel?.id, lat: OrderSession.shared.bookingModel?.dropoffLatitude, long: OrderSession.shared.bookingModel?.dropoffLongitude)
        
        stops = [pickupLocation] + (OrderSession.shared.bookingModel?.stops ?? []) + [destinationLocation]
    }
    
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
