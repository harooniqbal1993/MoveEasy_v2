//
//  LocationManager.swift
//  MoveEasy
//
//  Created by Haroon Iqbal on 11/12/2023.
//

//import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager
    var locationUpdated: ((CLLocation?) -> Void)?
    
    private override init() {
        locationManager = CLLocationManager()
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        // Other setup configurations if needed
    }
    
//    func requestLocationPermission() {
//        locationManager.requestWhenInUseAuthorization()
//    }
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            // Handle case where location services are not enabled
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // Handle the updated location
        print("Updated Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        locationUpdated?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location manager errors
        print("Location Manager Error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle changes in location authorization status
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted, start updating location
            startUpdatingLocation()
        case .denied, .restricted:
            // Permission denied, handle accordingly
            break
        case .notDetermined:
            // Permission not determined, can request permission here if needed
            break
        @unknown default:
            break
        }
    }
}
