//
//  ReceiptViewModel.swift
//  MoveEasy
//
//  Created by Apple on 09/02/1444 AH.
//

import Foundation

class ReceiptViewModel {
    
    var receiptModel: BookingTotalModel? = nil
    var actualTime: Int = Int(OrderSession.shared.bookingModel?.completionTime ?? 0) / 60 // 20
    var time: Int = Int(OrderSession.shared.bookingModel?.completionTime ?? 0) / 60
    
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
    
    var workTime: String {
        return receiptModel?.workTime ?? "0.00" // "0.00"
    }
    
    var travelTime: String {
        return receiptModel?.traveltime ?? "0.00" // "0.00"
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
    
    func getOrderSummary(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.getOrderSummary(userID: "123", bookingID: "\(OrderSession.shared.order?.id ?? 0)") { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func getBooking(bookingID: String?, completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.getBookingSummary(bookingID: bookingID ?? "") { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            self.receiptModel = result?.bookingTotalModel
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
