//
//  MapViewController.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 06.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var adress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
    }
    
    @IBAction func addLocationToNew() {
        performSegue(withIdentifier: "backToNewText", sender: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            
            let coordinate = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            let coder = CLGeocoder()
            coder.reverseGeocodeLocation(coordinate) { (myPlaces, Error) -> Void in
                if let place = myPlaces?.first {
                    let country = place.country ?? ""
                    let region = place.administrativeArea ?? ""
                    let city = place.locality ?? ""
                    let place = place.name ?? ""
                    self.adress = (country + ", " + region + ", " + city + ", " + place)
                }
                
            }
            
            let currentRadius: CLLocationDistance = 500
            let currentRegion = MKCoordinateRegionMakeWithDistance(currentLocation, currentRadius * 2, currentRadius * 2)
            self.mapView.setRegion(currentRegion, animated: true)
            
        }
    }
}
