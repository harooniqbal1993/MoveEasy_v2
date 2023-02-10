//
//  FeedbackModel.swift
//  MoveEasy
//
//  Created by Apple on 11/02/1444 AH.
//

import Foundation

struct FeedbackRequest: Encodable {
    
    var id: Int? = nil
    var rating: Int? = nil
    var feedback: String? = nil
    var comments: String? = nil
    var driverId: Int? = nil
    var userIdD: Int? = nil
    var tip: String? = nil
}
