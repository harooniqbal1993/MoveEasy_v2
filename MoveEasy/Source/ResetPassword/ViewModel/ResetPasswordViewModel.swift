//
//  ResetPasswordViewModel.swift
//  MoveEasy
//
//  Created by Haroon Iqbal on 18/04/2023.
//

import Foundation

class ResetPasswordViewModel {
    
    func resetPassword(email: String?, password: String, completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.resetPassword(email: email ?? "", newPassword: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
}
