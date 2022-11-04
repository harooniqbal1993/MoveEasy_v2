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
    
    var baseFare: Float {
        return 100
    }
    
    var distance: Float {
        return 20
    }
    
    var subTotal: Float {
        return 500
    }
    
    var gst: Float {
        return 0.00
    }
    
    var total: Float {
        return 800
    }
}
