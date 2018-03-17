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
import Cosmos

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
        mapView.delegate = self
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
        var coordinate = mapView.userLocation.coordinate
        coordinate.latitude = mapView.userLocation.coordinate.latitude
        coordinate.longitude = mapView.userLocation.coordinate.longitude
        mapView.addAnnotation(PlaceAnnotation(locationName: "El'feleva bashnya. Paris.", coordinate: coordinate, rating: 3.8))
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

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceAnnotation else {
            return nil
        }

        let identifier = "placeAnnotationView"
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 32))
        rightButton.imageView?.contentMode = .scaleToFill
        rightButton.setImage(UIImage(named: "GoToAnnotationDetails"), for: .normal)
        view.rightCalloutAccessoryView = rightButton

        var starSetting = CosmosSettings()
        starSetting.starMargin = 0
        starSetting.fillMode = .precise
        starSetting.updateOnTouch = false
        starSetting.emptyBorderColor = .clear
        starSetting.emptyColor = .lightGray
        starSetting.filledBorderColor = .clear
        starSetting.filledColor = UIColor(red: 52 / 255, green: 120 / 255, blue: 246 / 255, alpha: 1)
        let starView = CosmosView(settings: starSetting)
        starView.rating = annotation.rating
        view.detailCalloutAccessoryView = starView
        
        return view
    }
}
