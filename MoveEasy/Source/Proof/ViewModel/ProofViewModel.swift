//
//  ProofViewModel.swift
//  MoveEasy
//
//  Created by Apple on 27/12/1443 AH.
//

import Foundation

class ProofViewModel {
    
    func saveNotes(bookingID: Int, notes: String, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        NetworkService.shared.saveNotes(notesRequest: NotesRequest(bookingId: bookingID, notes: notes, driverId: DriverSession.shared.driver?.id)) { result, error in
            if result?.statusCode == 200 {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
