//
//  HttpUtility.swift
//  MovEasyDriver
//
//  Created by Apple on 07/06/1443 AH.
//

import Foundation

class HttpUtility {
    
    func getApiData<T: Decodable>(url: URL, resultType: T.Type, completionHandler: @escaping(_ result: T?, _ error: String?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer "+(Defaults.authToken ?? ""), forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { responseData, httpUrlResponse, error in
            if error == nil && responseData != nil && responseData?.count != 0 {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    completionHandler(result, nil)
                } catch let error {
                    debugPrint(url)
                    debugPrint("Error occured while decoding : ", error.localizedDescription)
                    completionHandler(nil, error.localizedDescription)
                }
            } else {
                debugPrint("something went wrong")
                completionHandler(nil, error?.localizedDescription)
            }
        }.resume()
    }
    
    func postApiData<T: Decodable>(url: URL, requestBody: Data, resultType: T.Type, completionHandler: @escaping(_ result: T?, _ error: String?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBody
        //        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer "+(Defaults.authToken ?? ""), forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            if let apiError = error {
                debugPrint("API ERROR: ", apiError.localizedDescription)
                return
            }
            let str = String(decoding: data!, as: UTF8.self)
            print(str)
            if data != nil && data?.count != 0 {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    completionHandler(response, nil)
                } catch let error {
                    debugPrint("POST api error: ", error)
                    completionHandler(nil, error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    func postAttachment (fileName: String, imageData: Data, fileKey: String, url: String, completion: @escaping(String?) -> Void)  {
        let boundary = UUID().uuidString
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer "+(Defaults.authToken ?? ""), forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fileKey)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/*\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
            
            if let checkResponse = response as? HTTPURLResponse {
                if checkResponse.statusCode == 200 {
                    if let json = data {
                        let str = String(decoding: json, as: UTF8.self)
                        print("", str)
                        completion(str)
                    }
                }
                else {
                    guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                        completion(nil)
                        return
                    }
                    let jsonString = String(data: data, encoding: .utf8)!
                    completion(nil)
                }
            } else {
                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    completion(nil)
                    return
                }
                completion(nil)
            }
        }).resume()
    }
    
    
    func postWithQueryStringApiData<T: Decodable>(url: URL, resultType: T.Type, completionHandler: @escaping(_ result: T?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        //        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer "+(Defaults.authToken ?? ""), forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            let str = String(decoding: data!, as: UTF8.self)
            print(str)
            if data != nil && data?.count != 0 {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    completionHandler(response)
                } catch let error {
                    debugPrint("POST api error: ", error)
                    completionHandler(nil)
                }
            }
        }.resume()
    }
}
