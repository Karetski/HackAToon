//
//  MapViewController.swift
//  HackAToon
//
//  Created by Alexey Karetski on 3/17/18.
//  Copyright © 2018 Karetski. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet fileprivate weak var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var currentLatitude: Double?
    fileprivate var cuurentLongitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        currentLatitude = location.coordinate.latitude
        currentLatitude = location.coordinate.longitude
    }
    
}

