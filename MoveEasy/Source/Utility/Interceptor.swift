//
//  Interceptor.swift
//  MoveEasy
//
//  Created by Haroon Iqbal on 10/05/2023.
//

import Foundation

class Interceptor {
    
    func refreshToken<T: Decodable>(url: URL = URL(string: NetworkService.shared.baseURL + Constants.EndPoints.login.rawValue)!, requestBody: LoginRequest = LoginRequest(email: Defaults.driverEmail ?? "", password: Defaults.password ?? "", rememberMe: true), resultType: T.Type = LoginResponse.self, completionHandler: @escaping(_ result: T?, _ error: String?) -> Void) {
        print("refeshToken()")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        //        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer "+(Defaults.authToken ?? ""), forHTTPHeaderField: "Authorization")
        
        do {
            let encodedRequest = try JSONEncoder().encode(requestBody)
            urlRequest.httpBody = encodedRequest
        } catch let error {
            debugPrint("Refresh Token Request Encoding error : ", error)
            completionHandler(nil, error.localizedDescription)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
            }

            if let apiError = error {
                debugPrint("API ERROR: ", apiError.localizedDescription)
                completionHandler(nil, apiError.localizedDescription)
                return
            }
            
            if let httpResponse = httpUrlResponse as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 401 {
                    completionHandler(nil, "Token has expired!")
                }
            }
            
            if data != nil && data?.count != 0 {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!) as? LoginResponse
                    Defaults.authToken = response?.token
                    completionHandler(nil, nil)
                } catch let error {
                    debugPrint("POST api error: ", error)
                    completionHandler(nil, error.localizedDescription)
                }
            }
        }.resume()
    }
}
