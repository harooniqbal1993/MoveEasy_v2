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
    
    var onAccept: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if OrderSession.shared.bookingModel?.pickupLatitude == nil || OrderSession.shared.bookingModel?.pickupLongitude == nil || OrderSession.shared.bookingModel?.dropoffLatitude == nil || OrderSession.shared.bookingModel?.dropoffLongitude == nil {
            return
        }
        let pickupLat: Double = Double(OrderSession.shared.bookingModel?.pickupLatitude ?? "0.0") ?? 0.0
        let pickupLng: Double = Double(OrderSession.shared.bookingModel?.pickupLongitude ?? "0.0") ?? 0.0
        let dropoffLat: Double = Double(OrderSession.shared.bookingModel?.dropoffLatitude ?? "0.0") ?? 0.0
        let dropoffLng: Double = Double(OrderSession.shared.bookingModel?.dropoffLongitude ?? "0.0") ?? 0.0
        
        fetchRoute(from: CLLocationCoordinate2D(latitude: pickupLat, longitude: pickupLng), to: CLLocationCoordinate2D(latitude:dropoffLat, longitude: dropoffLng))
        return
        
        let jobDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JobDetailViewController") as! JobDetailViewController
        jobDetailViewController.onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        jobDetailViewController.onAccept = { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.onAccept?()
            })
        }
        let sheetController = SheetViewController(controller: jobDetailViewController, sizes:[.percent(0.6)], options: Constants.fittedSheetOptions)
        sheetController.cornerRadius = 0
        self.present(sheetController, animated: true, completion: nil)
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
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyDiLSRSAuqG7uV5vF_lkkMs5ORScLB8HYw")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResult["routes"] as? [Any] else {
                return
            }
            
            guard let route = routes[0] as? [String: Any] else {
                return
            }

            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            
            guard let bounds = route["bounds"] as? [String: Any] else {
                return
            }
            
            guard let northeast = bounds["northeast"] as? [String: Any] else {
                return
            }
            
            guard let startLat = northeast["lat"] as? Double else {
                return
            }
            
            guard let startLng = northeast["lng"] as? Double else {
                return
            }
            
            guard let southwest = bounds["southwest"] as? [String: Any] else {
                return
            }
            
            guard let endLat = southwest["lat"] as? Double else {
                return
            }
            
            guard let endLng = southwest["lng"] as? Double else {
                return
            }
            
            //Call this method to draw path on map
            DispatchQueue.main.async {
                let startPoint = CLLocationCoordinate2D(latitude: startLat, longitude: startLng)
                let endPoint = CLLocationCoordinate2D(latitude: endLat,longitude: endLng)
                let bounds = GMSCoordinateBounds(coordinate: startPoint, coordinate: endPoint)
                let camera = self.mapView.camera(for: bounds, insets: UIEdgeInsets())!
                self.mapView.camera = camera
                self.drawPath(from: polyLineString)
//                let camera = self.mapView.camera(for: bounds, insets: UIEdgeInsets())!
//                self.mapView.camera = camera
                
            }
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
//        let goOnlineViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoOnlineViewController") as! GoOnlineViewController
//        let sheetController = SheetViewController(controller: goOnlineViewController, sizes:[.percent(0.6)], options: Constants.fittedSheetOptions)
//        sheetController.cornerRadius = 0
//        self.present(sheetController, animated: true, completion: nil)
        dismiss(animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("location : ", locations.last)
        let location = locationManager.location?.coordinate
        cameraMoveToLocation(toLocation: location)
    }
}
