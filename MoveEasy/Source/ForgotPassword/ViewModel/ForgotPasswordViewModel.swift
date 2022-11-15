//
//  ForgotPasswordViewModel.swift
//  MoveEasy
//
//  Created by Apple on 04/11/2022.
//

import Foundation

struct ForgotPasswordModel: Decodable {
    var statusCode: Int? = nil
    var message: String? = nil
}

class ForgotPasswordViewModel {
    
    func forgotPassword(email: String, completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.forgotPassword(email: email) { result, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
