//
//  Constants.swift
//  PlanLoaderiOS
//
//  Created by Apple on 14/06/1443 AH.
//

import Foundation
import UIKit
import FittedSheets

class Constants {
    static let themeColor = UIColor.init(red: 51/255, green: 42/255, blue: 136/255, alpha: 1.0)
    static let buttonGreen = UIColor.init(red: 104/255, green: 229/255, blue: 47/255, alpha: 1.0)
    static let kLogin: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    static let kMain: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    static let fittedSheetOptions = SheetOptions(
        // The full height of the pull bar. The presented view controller will treat this area as a safearea inset on the top
        pullBarHeight: 0,
        
        // The corner radius of the shrunken presenting view controller
        presentingViewCornerRadius: 0,
        
        // Extends the background behind the pull bar or not
        shouldExtendBackground: true,
        
        // Attempts to use intrinsic heights on navigation controllers. This does not work well in combination with keyboards without your code handling it.
        setIntrinsicHeightOnNavigationControllers: true,
        
        // Pulls the view controller behind the safe area top, especially useful when embedding navigation controllers
        useFullScreenMode: true,
        
        // Shrinks the presenting view controller, similar to the native modal
        shrinkPresentingViewController: true,
        
        // Determines if using inline mode or not
        useInlineMode: false,
        
        // Adds a padding on the left and right of the sheet with this amount. Defaults to zero (no padding)
        horizontalPadding: 0,
        
        // Sets the maximum width allowed for the sheet. This defaults to nil and doesn't limit the width.
        maxWidth: nil
    )
    
    enum EndPoints: String {
        case login = "Auth/loginDriver"
        case registerDriver = "Auth/signupDriver"
        case forgotPassword = "Auth/forgotPassword"
        case getDriverStatus = "DriverDashboardAPI/getDriverStatus"
        case setDriverStatus = "DriverDashboardAPI/setDriverStatus"
        case dashboard = "DriverDashboardAPI/dashboard"
        case getTodaysBookings = "DriverDashboardAPI/getTodaysBookings"
        case getDriverDetail = "DriverDetailAPI"
        case acceptBooking = "BookingAssignmentsAPI/AcceptBooking"
        case saveNotes = "DriverBookingsAPI/saveNotes"
        case getBooking = "BookingsAPI"
        case startMoving = "DriverBookingsAPI/startMoving"
        case pauseMoving = "DriverBookingsAPI/pauseMoving"
        case finishMoving = "DriverBookingsAPI/finishMoving"
        case pickupFiles = "BookingsAPI/PickupFiles"
        case feedback = "Feedback/FeedbackFromDriver"
        case forgotTimer = "ManualStartBookingAPI/ManualStartBooking"
        case getOrderSummary = "ForgotToStartBooking/GetOrderSummary"
//        case getBookingSummary = "BookingsAPI"
    }
    
    enum NotificationObserver: String {
        case UPDATE_SWIMLANE = "UPDATE_SWIMLANE"
        
        var value: Notification.Name {
            return Notification.Name(rawValue: self.rawValue)
        }
    }
}
