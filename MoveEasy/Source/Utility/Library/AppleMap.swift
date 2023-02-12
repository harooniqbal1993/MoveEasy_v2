//
//  AppleMap.swift
//  MoveEasy
//
//  Created by Nimra Jamil on 2/12/23.
//

import CoreLocation
import MapKit
import UIKit

class AppleMap {
    
    var source: CLLocationCoordinate2D? = nil
    var destination: CLLocationCoordinate2D? = nil

    init(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        self.source = source
        self.destination = destination
    }
    
    // If you are calling the coordinate from a Model, don't forgot to pass it in the function parenthesis.
    func present(in viewController: UIViewController, sourceView: UIView) {
        
        if let source = self.source, let destination = self.destination {
            //            CLLocationCoordinate2D(latitude: 51.792014, longitude: -114.105279)
            let source = MKMapItem(placemark: MKPlacemark(coordinate: source))
            source.name = "Source"
            
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            destination.name = "Destination"
            
            MKMapItem.openMaps(
              with: [source, destination],
              launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            )
        }
        
        return
        
        let actionSheet = UIAlertController(title: "Open Location", message: "Choose an app to open direction", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
            // Pass the coordinate inside this URL
            let url = URL(string: "comgooglemaps://?saddr=51.792014,-114.105279&daddr=51.049999,-114.066666)&directionsmode=driving&zoom=14&views=traffic")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
//            let source = MKMapItem(coordinate: .init(latitude: 51.792014, longitude: -114.105279), name: "Source")
//            // Pass the coordinate that you want here
//            let coordinate = CLLocationCoordinate2DMake(51.049999,-114.066666)
//            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
//            mapItem.name = "Destination"
//            mapItem.openInMaps(with: [source, destination],
//                               launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            
            if let source = self.source, let destination = self.destination {
                //            CLLocationCoordinate2D(latitude: 51.792014, longitude: -114.105279)
                let source = MKMapItem(placemark: MKPlacemark(coordinate: source))
                source.name = "Source"
                
                let destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
                destination.name = "Destination"
                
                MKMapItem.openMaps(
                  with: [source, destination],
                  launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                )
            }
            
//            if let destination = self.destination {
////                CLLocationCoordinate2D(latitude: 51.049999, longitude: -114.066666)
//                let destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
//                destination.name = "Destination"
//            }
//
//            MKMapItem.openMaps(
//              with: [source, destination],
//              launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//            )
        }))
        actionSheet.popoverPresentationController?.sourceRect = sourceView.bounds
        actionSheet.popoverPresentationController?.sourceView = sourceView
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
