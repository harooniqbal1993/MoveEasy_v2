//
//  Timer.swift
//  MoveEasy
//
//  Created by Apple on 11/12/1443 AH.
//

import Foundation

//class StopWatch {
//
//    var startTime: TimeInterval?
//    var currentTime: TimeInterval {
//        return NSDate.timeIntervalSinceReferenceDate
//    }
//    var elapsedTime: TimeInterval {
//        return currentTime - (startTime ?? 0.0)
//    }
//    var freezedTime: TimeInterval = 0.0
//    var inString: String {
//        let time = elapsedTime
//        let minutes = Int(time) / 60
//        let seconds = Int(time) % 60
//        let fraction = Int(time * 100) % 100
//        let string = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds) + ":" + String(format: "%02d", fraction)
//        return string
//    }
//
//    func start() {
//        if startTime == nil {
//            startTime = currentTime
//        } else {
//            startTime = currentTime - freezedTime
//        }
//    }
//
//    func reset() {
//        startTime = nil
//    }
//
//    func pause() {
//        freezedTime = elapsedTime
//    }
//}

class StopWatch {
    
    var startTime: TimeInterval?
    var currentTime: TimeInterval {
        return NSDate.timeIntervalSinceReferenceDate
    }
    var elapsedTime: TimeInterval {
        return (startTime != nil ? currentTime - startTime! : 0.0) + freezedTime
    }
    var freezedTime: TimeInterval = 0.0
    var inString: String {
        let time = elapsedTime
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let fraction = Int(time * 100) % 100
        let string = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds) + ":" + String(format: "%02d", fraction)
        return string
    }
    
    var inSeparateString: (String, String, String) {
        let time = elapsedTime
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let fraction = Int(time * 100) % 100
        let string = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds) + ":" + String(format: "%02d", fraction)
        return (String(format: "%02d", minutes), String(format: "%02d", seconds), String(format: "%02d", fraction))
    }
    
    func start(from seconds: TimeInterval? = nil) {
        if let seconds = seconds {
            startTime = currentTime - seconds
        } else if startTime == nil {
            startTime = currentTime
        } else {
            startTime = currentTime - freezedTime
        }
    }
    
    func reset() {
        startTime = nil
        freezedTime = 0.0
    }
    
    func pause() {
        freezedTime = elapsedTime
    }
}

