//
//  FileUploader.swift
//  MoveEasy
//
//  Created by Apple on 06/02/1444 AH.
//

import Foundation

class FileUploader {
    
    struct Media {
        let key: String
        let fileName: String
        let data: Data
        let mimeType: String

        init?(withImage data: Data, filename: String = "\(arc4random()).jpeg", forKey key: String = "file", mimeType: String = "image/*") {
            self.key = key
    //        self.fileName = "\(arc4random()).jpeg"
            self.mimeType = mimeType
            self.fileName = "\(filename)"
            self.data = data
            
    //        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
    //        self.data = data
        }

    }
    
    // filename: String?, file: [Data]?, fileKey: String? = "file"
    
    func formDataUpload<T: Decodable>(url: URL, parameters: [String : Any]? = nil, media: [Media] = [], authToken: String? = nil, resultType: T.Type, completion: @escaping (_ result: T?, _ error: String?) -> Void) {
        let boundary = generateBoundary()
        var request = URLRequest(url: url)
        
//        guard let mediaImage = Media(withImage: file ?? Data(), filename: filename ?? "", forKey: fileKey ?? "file") else { return }
        
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = [
            "X-User-Agent": "ios",
            "Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Authorization": "Bearer "+(authToken ?? "")
        ]
        
        let dataBody = createDataBody(withParameters: parameters, media: media, boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let apiError = error {
                debugPrint("API ERROR: ", apiError.localizedDescription)
                completion(nil, apiError.localizedDescription)
                return
            }
            let str = String(decoding: data!, as: UTF8.self)
            print(str)
            if data != nil && data?.count != 0 {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    completion(response, nil)
                } catch let error {
                    debugPrint("POST api error: ", error)
                    completion(nil, error.localizedDescription)
                }
            }
        }.resume()
    }

    private func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    private func createDataBody(withParameters params: [String: Any]?, media: [Media]?, boundary: String) -> Data {

        let lineBreak = "\r\n"
        var body = Data()

        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value as! String + lineBreak)")
            }
        }

        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
