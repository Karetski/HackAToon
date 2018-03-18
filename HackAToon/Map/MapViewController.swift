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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let locationManager = CLLocationManager()
    private let placesService = PlacesService()
    private var searchResultController: UISearchController?
    private var isRequestInProgress: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupMap()
        setupSearchBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        moveToCurrentLocation()
    }

    private func setupAppearance() {
        currentLocationBackground.layer.cornerRadius = 8.0
    }

    private func setupMap() {
        mapView.showsUserLocation = true
        mapView.delegate = self
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
        moveTo(location: currentLocation)
        loadPlaces(in: currentLocation)
    }

    private func moveTo(location: CLLocationCoordinate2D) {
        mapView.setRegion(
            MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.1, 0.1)),
            animated: true
        )
    }

    @IBAction func currentLocationTouchUpInside(_ sender: UIButton) {
        moveToCurrentLocation()
    }

    @IBAction func mapLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }

        let touchPoint = sender.location(in: mapView)
        let location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        loadPlaces(in: location)
    }

    func loadPlaces(in location: CLLocationCoordinate2D) {
        isRequestInProgress = true
        activityIndicator.startAnimating()
        placesService.fetchPlaces(on: location) { [weak self] (result) in
            self?.isRequestInProgress = false
            switch result {
            case .success(let places):
                self?.updateAnnotations(for: places)
            case .failure(let error):
                self?.activityIndicator.stopAnimating()
                print("Error: \(error)")
            }
        }
    }

    func updateAnnotations(for places: [PlaceDescription]) {
        let placeAnnotations = places.map { (place) in
            return PlaceAnnotation(
                locationName: place.name,
                coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude),
                rating: place.rating,
                identifier: place.identifier
            )
        }
        mapView.removeAnnotations(placeAnnotations)
        mapView.addAnnotations(placeAnnotations)
        activityIndicator.stopAnimating()
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

    private func setupSearchBar() {
        let locationSearchTable = ResultSearchController(nibName: "ResultSearchController", bundle: nil)
        locationSearchTable.delegate = self
        searchResultController = UISearchController(searchResultsController: locationSearchTable)
        searchResultController?.searchResultsUpdater = locationSearchTable
        navigationItem.titleView = searchResultController?.searchBar
        searchResultController?.hidesNavigationBarDuringPresentation = false
        searchResultController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
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
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 24))
        rightButton.imageView?.contentMode = .scaleToFill
        rightButton.setImage(#imageLiteral(resourceName: "GoToInstagram"), for: .normal)
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

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? PlaceAnnotation else {
            return
        }

        openLocation(by: annotation.identifier)
    }

    private func openLocation(by identifier: String) {
        guard let url = URL(string: "instagram://location?id=" + identifier),
            UIApplication.shared.canOpenURL(url) else {
                let alertController = UIAlertController(
                    title: "Failed",
                    message: "Instagram is not installed on your device!",
                    preferredStyle: .alert
                )
                alertController.addAction(
                    UIAlertAction(title: "OK", style: .cancel)
                )
                navigationController?.present(
                    alertController,
                    animated: true
                )
                return
        }
        UIApplication.shared.open(url)
    }
}

extension MapViewController: SearchResultDelegate {
    func scrollTo(coordinate: CLLocationCoordinate2D) {
        moveTo(location: coordinate)
    }
}
