//
//  NotesRequest.swift
//  MoveEasy
//
//  Created by Apple on 27/12/1443 AH.
//

import Foundation

struct NotesRequest: Encodable {
    var bookingId: Int? = nil
    var notes: String? = nil
    var driverId: Int? = nil
}
