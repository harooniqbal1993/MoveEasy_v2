//
//  FeedbackViewModel.swift
//  MoveEasy
//
//  Created by Apple on 11/02/1444 AH.
//

import Foundation

class FeedbackViewModel {
    
    var rating: Double? = 3
    
    func submitFeedback(rating: Int?, comments: String?, userID: Int?, tip: String?, completion: @escaping (_ result: LoginResponse?, _ error: String?) -> Void) {
        let feedbackRequest: FeedbackRequest = FeedbackRequest(id: 0, rating: rating, comments: comments, userIdD: userID, tip: tip)
        
        NetworkService.shared.feedback(feedbackRequest: feedbackRequest) { result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            completion(result, nil)
        }
    }
}
