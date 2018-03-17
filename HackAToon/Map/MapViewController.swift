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

class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationBackground: UIVisualEffectView!

    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupMap()
    }

    private func setupAppearance() {
        currentLocationBackground.layer.cornerRadius = 8.0

    }
    
    private func setupMap() {
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    private func moveToCurrentLocation() {
        guard let currentLocation = mapView.userLocation.location?.coordinate else {
            return
        }
        self.mapView.setRegion(
            MKCoordinateRegionMake(currentLocation, MKCoordinateSpanMake(0.1, 0.1)),
            animated: true
        )
    }

    @IBAction func currentLocationTouchUpInside(_ sender: UIButton) {
        moveToCurrentLocation()
    }

    private func screenDistance() -> (width: Double, height: Double) {
        let mapRect = self.mapView.visibleMapRect
        
        let eastMapPointX = MKMapPointMake(MKMapRectGetMinX(mapRect), MKMapRectGetMidY(mapRect))
        let westMapPointX = MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMidY(mapRect))
        let screenDistanceWidth = MKMetersBetweenMapPoints(eastMapPointX, westMapPointX)
        
        let northMapPointY = MKMapPointMake(MKMapRectGetMinY(mapRect), MKMapRectGetMidX(mapRect))
        let southMapPointY = MKMapPointMake(MKMapRectGetMaxY(mapRect), MKMapRectGetMidX(mapRect))
        let screenDistanceHeight = MKMetersBetweenMapPoints(northMapPointY, southMapPointY)
        
        return (screenDistanceWidth, screenDistanceHeight)
    }
}

extension MapViewController: CLLocationManagerDelegate {

}
