//
//  VerificationCodeViewModel.swift
//  MoveEasy
//
//  Created by Haroon Iqbal on 15/04/2023.
//

import Foundation

struct VerificationCodeConfirmationRequest: Encodable {
    var email: String? = nil
    var code: String? = nil
}

class VerificationCodeViewModel {
    
    func verificationCodeConfirmation(email: String, code: String, completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.verifyForgetPasswordCode(verificationCodeConfirmationRequest: VerificationCodeConfirmationRequest(email: email, code: code)) { result, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
