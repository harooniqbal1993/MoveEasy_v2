//
//  HttpUtility.swift
//  MovEasyDriver
//
//  Created by Apple on 07/06/1443 AH.
//

import Foundation

struct ImageStore: Encodable {
    var bookingId: Int? = nil
    var image: Data? = nil
}

class HttpUtility {
    
    func getApiData<T: Decodable>(url: URL, resultType: T.Type, completionHandler: @escaping(_ result: T?, _ error: String?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer "+(Defaults.authToken ?? ""), forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { responseData, httpUrlResponse, error in
            print("URL : ", url)
            
            if let responseData = responseData {
                let str = String(decoding: responseData, as: UTF8.self)
                print(str)
            }
            
            if let httpResponse = httpUrlResponse as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 401 {
                    completionHandler(nil, "Token has expired!")
                }
            }
            
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
                debugPrint("URL: ", url)
                debugPrint("something went wrong : ", error?.localizedDescription ?? "")
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
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    completionHandler(response, nil)
                } catch let error {
                    debugPrint("POST api error: ", error)
                    completionHandler(nil, error.localizedDescription)
                }
            }
        }.resume()
    }
    
//    func uploadBinaryImage(imageUploadEndpoint: URL?, image: UIImage, bookingId: String) {
//
//        guard let url = imageUploadEndpoint else { return }
//        let boundary = generateBoundary()
//        var request = URLRequest(url: url)
//
//        let parameters = ["bookingId": bookingId] as [String : Any]
//
//        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
//
//        request.httpMethod = "POST"
//
//        request.allHTTPHeaderFields = [
//                    "X-User-Agent": "ios",
//                    "Accept-Language": "en",
//                    "Accept": "application/json",
//                    "Content-Type": "multipart/form-data; boundary=<calculated when request is sent>",
//                    "Authorization": "Bearer "+(Defaults.authToken ?? "")
//                ]
//
//        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
//        request.httpBody = dataBody
//
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print(response)
//            }
//
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                } catch {
//                    print(error)
//                }
//            }
//            }.resume()
//    }
//
//
//    func generateBoundary() -> String {
//        return "Boundary-\(NSUUID().uuidString)"
//    }
//
//    func createDataBody(withParameters params: [String: Any]?, media: [Media]?, boundary: String) -> Data {
//
//        let lineBreak = "\r\n"
//        var body = Data()
//
//        if let parameters = params {
//            for (key, value) in parameters {
//                body.append("--\(boundary + lineBreak)")
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
//                body.append("\(value as! String + lineBreak)")
//            }
//        }
//
//        if let media = media {
//            for photo in media {
//                body.append("--\(boundary + lineBreak)")
//                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
//                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
//                body.append(photo.data)
//                body.append(lineBreak)
//            }
//        }
//
//        body.append("--\(boundary)--\(lineBreak)")
//
//        return body
//    }
    
    func postAttachment (fileName: String, imageData: Data, fileKey: String, url: String, completion: @escaping(String?, _ error: String?) -> Void)  {
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
                        completion(str, nil)
                    }
                }
                else {
                    guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                        completion(nil, "Something went wrong")
                        return
                    }
                    let jsonString = String(data: data, encoding: .utf8)!
                    completion(jsonString, nil)
                }
            } else {
                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    completion(nil, nil)
                    return
                }
                completion(nil, nil)
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
            print("URL : ", url)
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

//extension Data {
//    mutating func append(_ string: String) {
//        if let data = string.data(using: .utf8) {
//            append(data)
//        }
//    }
//}
//
//
//struct Media {
//    let key: String
//    let fileName: String
//    let data: Data
//    let mimeType: String
//
//    init?(withImage image: UIImage, forKey key: String) {
//        self.key = key
//        self.mimeType = "image/jpg"
//        self.fileName = "\(arc4random()).jpeg"
//
//        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
//        self.data = data
//    }
//}
