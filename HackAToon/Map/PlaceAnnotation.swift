//
//  PlaceAnnotation.swift
//  HackAToon
//
//  Created by Andrei Rybak on 3/17/18.
//  Copyright © 2018 Karetski. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let rating: Double
    let identifier: String

    init(locationName: String, coordinate: CLLocationCoordinate2D, rating: Double, identifier: String) {
        self.title = locationName
        self.coordinate = coordinate
        self.rating = rating
        self.identifier = identifier
        super.init()
    }
}

func ==<T: PlaceAnnotation>(lhs: T, rhs: T) -> Bool {
    return
        lhs.title == rhs.title &&
        lhs.rating == rhs.rating &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
}
