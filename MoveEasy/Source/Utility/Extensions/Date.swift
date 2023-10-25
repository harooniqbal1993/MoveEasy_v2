//
//  Date.swift
//  PlanLoaderiOS
//
//  Created by Apple on 21/09/1443 AH.
//

import Foundation

extension Date {
    func getFormattedDate(rawDate: String , formatter: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = rawDate // "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter // "MMM dd,yyyy"
        
        let date: Date? = dateFormatterGet.date(from: rawDate)
        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }
}
