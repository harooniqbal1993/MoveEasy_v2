//
//  NetworkService.swift
//  MoveEasy
//
//  Created by Apple on 17/12/1443 AH.
//

import Foundation

class NetworkService {
    let baseURL: String = "https://moveasydriver.anadeemus.ca/api/"
    var httpUtility: HttpUtility!
    
    static let shared = NetworkService(httpUtility: HttpUtility())
    
    private init(httpUtility: HttpUtility) {
        self.httpUtility = httpUtility
    }
    
    func loginDriver(loginRequest: LoginRequest, completion: @escaping (_ result: LoginResponse?, _ error: String?) -> Void) {
        let url = baseURL + Constants.EndPoints.login.rawValue
        do {
            let encodedRequest = try JSONEncoder().encode(loginRequest)
            httpUtility.postApiData(url: URL(string: url)!, requestBody: encodedRequest, resultType: LoginResponse.self) { result, error  in
                completion(result, nil)
            }
        } catch let error {
            debugPrint("Login Request Encoding error : ", error)
            completion(nil, error.localizedDescription)
        }
    }
    
    func registerDriver(loginRequest: RegisterRequest, completion: @escaping (_ result: RegisterResponse?, _ error: String?) -> Void) {
        let url = baseURL + Constants.EndPoints.registerDriver.rawValue
        do {
            let encodedRequest = try JSONEncoder().encode(loginRequest)
            httpUtility.postApiData(url: URL(string: url)!, requestBody: encodedRequest, resultType: RegisterResponse.self) { result, error in
                completion(result, nil)
            }
        } catch let error {
            debugPrint("registerDriver Request Encoding error : ", error)
            completion(nil, error.localizedDescription)
        }
    }
    
    func dashboard(completion: @escaping (_ result: HomeModel?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.dashboard.rawValue)?driverId=\(DriverSession.shared.driver?.id ?? 1125)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: HomeModel.self) { result, error in
            completion(result, error)
        }
    }
    
    func getTodaysBookings(completion: @escaping (_ result: [OrderModel]?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.dashboard.rawValue)?driverId=\(DriverSession.shared.driver?.id ?? 1125)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: [OrderModel].self) { result, error in
            completion(result, error)
        }
    }
    
    func setDriverStatus(status: Bool, completion: @escaping (_ result: DriverStatusModel?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.setDriverStatus.rawValue)?driverId=\(DriverSession.shared.driver?.id ?? 0)&status=\(status)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: DriverStatusModel.self) { result, error in
            completion(result, error)
        }
    }
    
    func getDriverDetail(completion: @escaping (_ result: DriverModel?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.getDriverDetail.rawValue)?email=\(Defaults.driverEmail ?? "")"
        httpUtility.getApiData(url: URL(string: url)!, resultType: DriverModel.self) { result, error in
            completion(result, error)
        }
    }
    
    func acceptBooking(bookingID: String, completion: @escaping (_ result: AcceptBookingModel?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.acceptBooking.rawValue)?driverId=\("1125")&bookingId=\(bookingID)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: AcceptBookingModel.self) { result, error in
            completion(result, error)
        }
    }
    
    func saveNotes(notesRequest: NotesRequest, completion: @escaping (_ result: NotesResponse?, _ error: String?) -> Void) {
        let url = baseURL + Constants.EndPoints.saveNotes.rawValue
        do {
            let encodedRequest = try JSONEncoder().encode(notesRequest)
            httpUtility.postApiData(url: URL(string: url)!, requestBody: encodedRequest, resultType: NotesResponse.self) { result, error in
                completion(result, error)
            }
        } catch {
            print("saveNotes Api Error: ", error)
            completion(nil, error.localizedDescription)
        }
    }
    
    func startMoving(bookingID: String, completion: @escaping (_ result: Bool?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.startMoving.rawValue)?driverId=\(Defaults.driverEmail ?? "")&bookingId=\(bookingID)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: Bool.self) { result, error in
            completion(result, error)
        }
    }
    
    func pauseMoving(bookingID: String, completion: @escaping (_ result: Bool?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.pauseMoving.rawValue)?driverId=\(Defaults.driverEmail ?? "")&bookingId=\(bookingID)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: Bool.self) { result, error in
            completion(result, error)
        }
    }
    
    func finishMoving(bookingID: String, completion: @escaping (_ result: FinishJobModel?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.finishMoving.rawValue)?driverId=\(Defaults.driverEmail ?? "")&bookingId=\(bookingID)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: FinishJobModel.self) { result, error in
            completion(result, error)
        }
    }
    
    func feedback(feedbackRequest: FeedbackRequest, completion: @escaping (_ result: LoginResponse?, _ error: String?) -> Void) {
        let url = baseURL + Constants.EndPoints.feedback.rawValue
        do {
            let encodedRequest = try JSONEncoder().encode(feedbackRequest)
            httpUtility.postApiData(url: URL(string: url)!, requestBody: encodedRequest, resultType: LoginResponse.self) { result, error  in
                completion(result, nil)
            }
        } catch let error {
            debugPrint("Login Request Encoding error : ", error)
            completion(nil, error.localizedDescription)
        }
    }
}
