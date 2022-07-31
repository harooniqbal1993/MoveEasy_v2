//
//  FileUploader.swift
//  MoveEasy
//
//  Created by Apple on 26/12/1443 AH.
//

import Foundation

class FileUploader {
    
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
}
