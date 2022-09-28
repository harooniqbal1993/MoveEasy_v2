//
//  ManageJobViewModel.swift
//  MoveEasy
//
//  Created by Apple on 09/01/1444 AH.
//

import Foundation

class ManageJobViewModel {
    
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
    
    func stopMoving(bookingID: String) {
        NetworkService.shared.finishMoving(bookingID: bookingID) { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    return
                }
            }
        }
    }
}
