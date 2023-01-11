//
//  ReceiptViewModel.swift
//  MoveEasy
//
//  Created by Apple on 09/02/1444 AH.
//

import Foundation

class ReceiptViewModel {
    
    var receiptModel: BookingTotalModel? = nil
    
    init(receiptModel: BookingTotalModel?) {
        self.receiptModel = receiptModel
    }
    
    var orderNumber: String {
        return "112"
    }
    
    var baseFare: String {
        return receiptModel?.baseFare ?? "0.00"
    }
    
    var distance: String {
        return receiptModel?.totalDistance ?? "0.00"
    }
    
    var subTotal: String {
        return receiptModel?.subtotal ?? "0.00"
    }
    
    var gst: String {
        return receiptModel?.gstandPst ?? "0.00"
    }
    
    var total: String {
        return receiptModel?.totalCharge ?? "0.00"
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
