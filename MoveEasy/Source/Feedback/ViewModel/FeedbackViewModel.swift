//
//  FeedbackViewModel.swift
//  MoveEasy
//
//  Created by Apple on 11/02/1444 AH.
//

import Foundation

class FeedbackViewModel {
    
    var rating: Double? = 3
    var selectedOptions: [String]? = []
    
    func submitFeedback(rating: Int?, comments: String?, userID: Int?, tip: String?, completion: @escaping (_ result: LoginResponse?, _ error: String?) -> Void) {
        let feedbackRequest: FeedbackRequest = FeedbackRequest(id: OrderSession.shared.bookingModel?.id ?? 0, rating: rating, comments: comments, userIdD: userID, tip: tip, feedback: self.selectedOptions)
        
        NetworkService.shared.feedback(feedbackRequest: feedbackRequest) { result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            completion(result, nil)
        }
    }
}
