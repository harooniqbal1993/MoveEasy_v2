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
    var pausedTime: TimeInterval? = 0
    
    init() {
        let pickupLocation = Stop(id: nil, stop: OrderSession.shared.bookingModel?.pickupLocation, personName: OrderSession.shared.bookingModel?.user?.firstName, personPhone: OrderSession.shared.bookingModel?.user?.phone, instructions: OrderSession.shared.bookingModel?.pickUpInstructions, bookingId: OrderSession.shared.bookingModel?.id, lat: OrderSession.shared.bookingModel?.pickupLatitude, long: OrderSession.shared.bookingModel?.pickupLongitude)
        
        let destinationLocation = Stop(id: nil, stop: OrderSession.shared.bookingModel?.dropoffLocation, personName: OrderSession.shared.bookingModel?.user?.firstName, personPhone: OrderSession.shared.bookingModel?.user?.phone, instructions: OrderSession.shared.bookingModel?.dropOffInstructions, bookingId: OrderSession.shared.bookingModel?.id, lat: OrderSession.shared.bookingModel?.dropofflatitude, long: OrderSession.shared.bookingModel?.dropoffLongitude)
        
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
    
    func timerLog(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.timerLog(driverID: DriverSession.shared.driver?.id ?? 1125, bookingId: "\(OrderSession.shared.bookingModel?.id ?? 0)", userId: "\(0)") { result, error in
            
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
    
    func updateBookingTimer(seconds: Int) {
        NetworkService.shared.updateBookingTime(driverID: DriverSession.shared.driver?.id ?? 1125, bookingId: "\(OrderSession.shared.bookingModel?.id ?? 0)", seconds: seconds) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func getUpdateBookingTime(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.getUpdatedBookingTime(driverID: DriverSession.shared.driver?.id ?? 1125, bookingId: "\(OrderSession.shared.bookingModel?.id ?? 0)") { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                self.pausedTime = result?.data
                completion(nil)
            }
        }
    }
}
