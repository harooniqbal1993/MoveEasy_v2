//
//  NetworkService.swift
//  MoveEasy
//
//  Created by Apple on 17/12/1443 AH.
//

import Foundation

class NetworkService {
//    https://neighbour.anadeemus.ca/swagger/index.html
    let baseURL: String = "https://driversapi.moovez.ca/api/" // "https://moveasydriver.anadeemus.ca/api/" // https://mov.anadeemus.ca/api/" // "https://moveasydriver.anadeemus.ca/api/"
    let customerURL: String = "https://admin.moovez.ca/api/" // "https://neighbour.anadeemus.ca/api/"
    
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
                completion(result, error)
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
    
    func forgotPassword(email: String, completion: @escaping (_ result: ForgotPasswordModel?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.forgotPassword.rawValue)?email=\(email)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: ForgotPasswordModel.self) { result, error in
            completion(result, error)
        }
    }
    
    func dashboard(completion: @escaping (_ result: HomeModel?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.dashboard.rawValue)?driverId=\(DriverSession.shared.driver?.id ?? 1125)"
//        let url = "\(baseURL+Constants.EndPoints.dashboard.rawValue)?driverId=\(DriverSession.shared.driver?.id ?? 1125)"
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
    
    func getDriverDetail(completion: @escaping (_ result: LoginResponse?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.getDriverDetail.rawValue)/\(Defaults.driverEmail ?? "")"
        httpUtility.getApiData(url: URL(string: url)!, resultType: LoginResponse.self) { result, error in
            completion(result, error)
        }
    }
    
    func acceptBooking(bookingID: String, completion: @escaping (_ result: AcceptBookingModel?, _ error: String?) -> Void) {
        let url = "\(customerURL+Constants.EndPoints.acceptBooking.rawValue)?driverId=\(DriverSession.shared.driver?.id ?? 1125)&bookingId=\(bookingID)"
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
        let url = "\(baseURL+Constants.EndPoints.startMoving.rawValue)?driverId=\(DriverSession.shared.driver?.id ?? 0)&bookingId=\(bookingID)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: Bool.self) { result, error in
            completion(result, error)
        }
    }
    
    func pauseMoving(bookingID: String, completion: @escaping (_ result: Bool?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.pauseMoving.rawValue)?driverId=\(DriverSession.shared.driver?.id ?? 0)&bookingId=\(bookingID)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: Bool.self) { result, error in
            completion(result, error)
        }
    }
    
    func finishMoving(bookingID: String, completion: @escaping (_ result: FinishJobModel?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.finishMoving.rawValue)?driverId=\(DriverSession.shared.driver?.id ?? 0)&bookingId=\(bookingID)"
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
    
    func forgotTimer(forgotTimerRequest: ForgotTimerRequest, completion: @escaping (_ result: ForgotTimerResponse?, _ error: String?) -> Void) {
        let url = "\(customerURL+Constants.EndPoints.forgotTimer.rawValue)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let encodedURL = encodedURL {
            do {
                let encodedRequest = try JSONEncoder().encode(forgotTimerRequest)
                httpUtility.postApiData(url: URL(string: encodedURL)!, requestBody: encodedRequest, resultType: ForgotTimerResponse.self) { result, error  in
                    completion(result, nil)
                }
            } catch let error {
                debugPrint("forgotTimer Request Encoding error : ", error)
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func getBooking(bookingID: String, completion: @escaping (_ result: FinishJobModel?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.finishMoving.rawValue)/\(bookingID)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: FinishJobModel.self) { result, error in
            completion(result, error)
        }
    }
    
    func getOrderSummary(userID: String, bookingID: String, completion: @escaping (_ result: FinishJobModel?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.getOrderSummary.rawValue)?userId=\(userID)&bookingID=\(bookingID)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: FinishJobModel.self) { result, error in
            completion(result, error)
        }
    }
    
    func getBookingSummary(bookingID: String, completion: @escaping (_ result: OrderSummaryModel?, _ error: String?) -> Void) {
        let url = "\(customerURL+Constants.EndPoints.getBooking.rawValue)/\(bookingID)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: OrderSummaryModel.self) { result, error in
            completion(result, error)
        }
    }
    
    func sendDeviceToken(driverID: Int, deviceToken: String, completion: @escaping (_ result: LoginResponse?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.addDriverDeviceID.rawValue)?id=\(driverID)&devicetoken=\(deviceToken)" // baseURL + Constants.EndPoints.addDriverDeviceID.rawValue
        httpUtility.postWithQueryStringApiData(url: URL(string: url)!, resultType: LoginResponse.self) { result, error in
            print("")
        }
    }
    
    func cancelBooking(bookingID: String, completion: @escaping (_ result: LoginResponse?, _ error: String?) -> Void) {
        let url = "\(customerURL+Constants.EndPoints.cancelBooking.rawValue)?bookingId=\(bookingID)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: LoginResponse.self) { result, error in
            completion(result, error)
        }
    }
    
    func timerLog(driverID: Int, bookingId: String, userId: String, completion: @escaping (_ result: LoginResponse?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.timerLog.rawValue)?driverId=\(driverID)&bookingId=\(bookingId)&userId=\(userId)"
        httpUtility.postWithQueryStringApiData(url: URL(string: url)!, resultType: LoginResponse.self) { result, error in
            print("")
        }
    }
    
    func decreaseTimer(driverID: Int, bookingId: String, seconds: Int, completion: @escaping (_ result: FinalJobResponse?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.decreaseTimer.rawValue)?driverId=\(driverID)&bookingId=\(bookingId)&seconds=\(seconds)"
        httpUtility.postWithQueryStringApiData(url: URL(string: url)!, resultType: FinalJobResponse.self) { result, error in
            completion(result, nil)
        }
    }
    
    func updateBookingTime(driverID: Int, bookingId: String, seconds: Int, completion: @escaping (_ result: LoginResponse?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.updateBookingTime.rawValue)?driverId=\(driverID)&bookingId=\(bookingId)&seconds=\(seconds)"
        httpUtility.postWithQueryStringApiData(url: URL(string: url)!, resultType: LoginResponse.self) { result, error in
            print("")
        }
    }
    
    func getUpdatedBookingTime(driverID: Int, bookingId: String, completion: @escaping (_ result: TimeResponse?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.getUpdatedBookingTime.rawValue)?driverId=\(driverID)&bookingId=\(bookingId)"
        httpUtility.getApiData(url: URL(string: url)!, resultType: TimeResponse.self) { result, error in
            completion(result, error)
        }
    }
    
    func verifyForgetPasswordCode(verificationCodeConfirmationRequest: VerificationCodeConfirmationRequest, completion: @escaping (_ result: ForgotTimerResponse?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.resetPasswordCode.rawValue)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let encodedURL = encodedURL {
            do {
                let encodedRequest = try JSONEncoder().encode(verificationCodeConfirmationRequest)
                httpUtility.postApiData(url: URL(string: encodedURL)!, requestBody: encodedRequest, resultType: ForgotTimerResponse.self) { result, error  in
                    completion(result, nil)
                }
            } catch let error {
                debugPrint("forgotTimer Request Encoding error : ", error)
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func resetPassword(email: String, newPassword: String, completion: @escaping (_ result: LoginResponse?, _ error: String?) -> Void) {
        let url = "\(baseURL+Constants.EndPoints.resetPassword.rawValue)?email=\(email)&newPassword=\(newPassword)" // baseURL + Constants.EndPoints.addDriverDeviceID.rawValue
        httpUtility.postWithQueryStringApiData(url: URL(string: url)!, resultType: LoginResponse.self) { result, error in
            completion(result, error)
        }
    }
}
