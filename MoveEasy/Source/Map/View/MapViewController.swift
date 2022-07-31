//
//  MapViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit
import GoogleMaps
import FittedSheets

class MapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        //        self.view.addSubview(mapView)
        self.view.insertSubview(mapView, at: 0)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        let goOnlineViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoOnlineViewController") as! GoOnlineViewController
        let sheetController = SheetViewController(controller: goOnlineViewController, sizes:[.percent(0.6)], options: Constants.fittedSheetOptions)
        sheetController.cornerRadius = 0
        self.present(sheetController, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("location : ", locations.last)
        let location = locationManager.location?.coordinate
        cameraMoveToLocation(toLocation: location)
    }
}
