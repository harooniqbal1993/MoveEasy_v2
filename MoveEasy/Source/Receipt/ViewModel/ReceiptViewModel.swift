//
//  ReceiptViewModel.swift
//  MoveEasy
//
//  Created by Apple on 09/02/1444 AH.
//

import Foundation

class ReceiptViewModel {
    
    var formType: String? = nil
    var receiptModel: BookingTotalModel? = nil
    var actualTime: Int = Int(OrderSession.shared.bookingModel?.completionTime ?? 0) / 60 // 20
    var time: Int = Int(OrderSession.shared.bookingModel?.completionTime ?? 0) / 60
    var isApprovedByCustomer: Bool? = false
    
    init(receiptModel: BookingTotalModel?) {
        self.receiptModel = receiptModel
    }
    
    var orderNumber: String {
        return ""
    }
    
    var baseFare: String {
        return receiptModel?.baseFare ?? "0.00"
    }
    
    var distance: String {
        return receiptModel?.totalDistance ?? "0.00"
    }
    
    var hourlyRate: String {
        return receiptModel?.hourlyRate ?? "0.00" // "0.00"
    }
    
//    var startTime: String {
//        if let startTime = OrderSession.shared.bookingModel?.startTime {
//            let refined = startTime.components(separatedBy: ".")
//            return refined[0]
//        }
//        return "0.00" // "0.00"
//    }
//
//    var breakTime: String {
//        return "0.00"
//    }
//
//    var endTime: String {
//        if let endTime = OrderSession.shared.bookingModel?.endTime {
//            let refined = endTime.components(separatedBy: ".")
//            return refined[0]
//        }
//        return "0.00" // "0.00"
//    }
//
//    var travelTime: String {
//        return receiptModel?.travelTime ?? "0.00" // "0.00"
//    }
    
    var startTime: String?
    var breakTime: Double? = 0.00
    var endTime: String?
    var travelTime: Double? = 0.5
    var totalJobTime: Double? = 0.00
    
    var workTime: String {
        return receiptModel?.workTime ?? "0.00" // "0.00"
    }
    
    var subTotal: String {
        return receiptModel?.totalChargeBTax ?? "0.00"
    }
    
    var gst: String {
        return receiptModel?.gstandPst ?? "0.00"
    }
    
    var total: String {
        return receiptModel?.totalCharge ?? "0.00"
    }
    
    var isAdjustNeeded: Bool {
        return time < actualTime
    }
    
    func decreaseTime() {
        time = time > 0 ? time - 1 : 0
    }
    
    func extractTime(jobTime: String?) -> String? {
        if let jobTime = jobTime {
            let refined = jobTime.components(separatedBy: ".")
            return refined[0]
        }
        return "0.00" // "0.00"
    }
    
    func totalCalculations() {
        
        let difference = calculateJobTimeDifference()
        let diffDouble = hoursStringToDecimal(difference)
        
        let total = (diffDouble ?? 0.0) + (travelTime ?? 0.0) + (breakTime ?? 0.0)
        self.totalJobTime = total
    }
    
    func calculateJobTimeDifference() -> String {
        let start: Date = startTime?.toDate(withFormat: "HH:mm:ss") ?? Date()
        let end: Date = endTime?.toDate(withFormat: "HH:mm:ss") ?? Date()

        let delta = (end - start)
        let finalHours = stringFromTimeInterval(interval: delta)
        return finalHours as String
    }
    
    func hoursStringToDecimal(_ hoursString: String) -> Double? {
        let components = hoursString.components(separatedBy: ":")
        
        // Check if there are two components
        guard components.count >= 2,
              let hours = Double(components[0]),
              let minutes = Double(components[1]) else {
            return nil // Invalid format
        }
        
        // Calculate decimal representation
        let decimalHours = hours + (minutes / 60.0)
        
        return decimalHours
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        //      return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
//        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        return NSString(format: "%0.2d.%0.2d",hours,minutes)
    }
    
    func getBooking(bookingID: String?, completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.getBookingSummary(bookingID: bookingID ?? "") { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            OrderSession.shared.bookingModel?.startTime = result?.startTime
            OrderSession.shared.bookingModel?.endTime = result?.endTime
            self.receiptModel = result?.bookingTotalModel
            self.startTime = self.extractTime(jobTime: result?.startTime)
            self.endTime = self.extractTime(jobTime: result?.endTime)
            self.totalCalculations()
            completion(nil)
        }
    }
    
    func adjustTime(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.decreaseTimer(driverID: DriverSession.shared.driver?.id ?? 1125, bookingId: "\(OrderSession.shared.bookingModel?.id ?? 0)", seconds: time*60) { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(error)
                    return
                }
                self.receiptModel = result?.data?.bookingTotalModel
//                if let result = result {
//                }
                completion(nil)
            }
        }
    }
    
    func chargePayment(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.chargePayment(bookingId: "\(OrderSession.shared.bookingModel?.id ?? 0)", completion: { result, error in
//        NetworkService.shared.chargePayment(bookingId: "\(1245)", completion: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(error)
                    return
                }
                if let result = result {
                    if result.StatusCode == 400 {
                        completion("Ask your customer to recheck his card details")
                        return
                    }
                }
                completion(nil)
            }
        })
    }
    
    func forgotTimer(completion: @escaping (_ error: String?) -> Void) {
        let forgotTimerRequest: ForgotTimerRequest = ForgotTimerRequest(id: 0, driverId: DriverSession.shared.driver?.id, startTime: startTime, endTime: endTime, bookingId: OrderSession.shared.bookingModel?.id, userId: OrderSession.shared.bookingModel?.userId, isApproved: true, FormType: formType)
        NetworkService.shared.forgotTimer(forgotTimerRequest: forgotTimerRequest) { result, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func getCustomerResponse(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.getCustomerResponse(bookingID: OrderSession.shared.bookingModel?.id ?? 0) { result, error in 
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                self.isApprovedByCustomer = result?.isApproved
                completion(nil)
            }
        }
    }
    
    func compareDates() -> Bool {
        return startTime?.toDate(withFormat: "HH:mm:ss")?.compare(endTime?.toDate(withFormat: "HH:mm:ss") ?? Date()) == ComparisonResult.orderedAscending
    }
}


//
//"bookingTotalModel": {
//    "coupon": null,
//    "discount": null,
//    "baseFare": "8",
//    "totalDistance": "40.00",
//    "gstandPst": "5.80",
//    "subtotal": "44.00",
//    "totalChargeBTax": "116.08",
//    "transferFee": "2.83",
//    "totalServiceFee": "7.08",
//    "totalCharge": "111.88",
//    "serviceFee": "2.50",
//    "labourSurcharge": "60",
//    "totalTaxGstpstrate": "5",
//    "totalDuration": null
//  },
