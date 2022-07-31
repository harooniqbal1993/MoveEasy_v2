//
//  Defaults.swift
//  PlanLoaderiOS
//
//  Created by Apple on 20/07/1443 AH.
//

import Foundation

class Defaults {
    
    private static let IS_LOGGED_IN: String = "is_logged_in"
    private static let AUTH_TOKEN: String = "auth_token"
    private static let USERNAME: String = "username"
    private static let DRIVER_EMAIL: String = "driver_email"
    private static let USER_IMAGE: String = "user_image"
    private static let DRIVER_STATUS: String = "driver_status"
    
    fileprivate static var userDefault: UserDefaults {
        get {
            return Foundation.UserDefaults.standard
        }
    }
    
    static var isLoggedIn: Bool? {
        get {
            let defaults = Defaults.userDefault
            if defaults.object(forKey: IS_LOGGED_IN) == nil {
                return false
            }
            return defaults.integer(forKey: IS_LOGGED_IN) == 0 ? false : true
        }
        set {
            if let newValue = newValue {
                Defaults.userDefault.set(newValue, forKey: IS_LOGGED_IN)
            } else {
                Defaults.userDefault.removeObject(forKey: IS_LOGGED_IN)
            }
        }
    }
    
    static var authToken: String? {
        get {
            return Defaults.userDefault.string(forKey: AUTH_TOKEN)
        }
        set {
            if let newValue = newValue {
                Defaults.userDefault.set(newValue, forKey: AUTH_TOKEN)
            } else {
                Defaults.userDefault.removeObject(forKey: AUTH_TOKEN)
            }
        }
    }
    
    static var username: String? {
        get {
            return Defaults.userDefault.string(forKey: USERNAME)
        }
        set {
            if let newValue = newValue {
                Defaults.userDefault.set(newValue, forKey: USERNAME)
            } else {
                Defaults.userDefault.removeObject(forKey: USERNAME)
            }
        }
    }
    
    static var driverEmail: String? {
        get {
            return Defaults.userDefault.string(forKey: DRIVER_EMAIL)
        }
        set {
            if let newValue = newValue {
                Defaults.userDefault.set(newValue, forKey: DRIVER_EMAIL)
            } else {
                Defaults.userDefault.removeObject(forKey: DRIVER_EMAIL)
            }
        }
    }
    
    static var userImage: String? {
        get {
            return Defaults.userDefault.string(forKey: USER_IMAGE)
        }
        set {
            if let newValue = newValue {
                Defaults.userDefault.set(newValue, forKey: USER_IMAGE)
            } else {
                Defaults.userDefault.removeObject(forKey: USER_IMAGE)
            }
        }
    }
    
    static var driverStatus: Bool? {
        get {
            return Defaults.userDefault.bool(forKey: DRIVER_STATUS)
        }
        set {
            if let newValue = newValue {
                Defaults.userDefault.set(newValue, forKey: DRIVER_STATUS)
            } else {
                Defaults.userDefault.removeObject(forKey: DRIVER_STATUS)
            }
        }
    }
    
    static func clearAll() {
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
}
