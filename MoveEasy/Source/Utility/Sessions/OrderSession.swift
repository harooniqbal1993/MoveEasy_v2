//
//  OrderSession.swift
//  MoveEasy
//
//  Created by Apple on 11/02/1444 AH.
//

import Foundation

class OrderSession {
    static let shared: OrderSession = OrderSession()
    var order: OrderModel? = nil
    
    private init() {}
    
    private func clearSession() {
        order = nil
    }
}
