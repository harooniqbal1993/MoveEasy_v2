//
//  Globals.swift
//  MoveEasy
//
//  Created by Apple on 17/12/1443 AH.
//

import Foundation

func getFormattedDate(rawDate: String, fromFormatter: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", formatter:String) -> String? {
    if rawDate == "" {
        return nil
    }
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = fromFormatter // "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = formatter // "MMM dd,yyyy"
    
    let date: Date? = dateFormatterGet.date(from: rawDate)
    print("Date",dateFormatterPrint.string(from: date ?? Date())) // Feb 01,2018
    return dateFormatterPrint.string(from: date ?? Date())
}

//2022-07-23T02:12:49.1564328-07:00
