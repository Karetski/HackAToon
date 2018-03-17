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

    init(locationName: String, coordinate: CLLocationCoordinate2D, rating: Double) {
        self.title = locationName
        self.coordinate = coordinate
        self.rating = rating
        super.init()
    }

}
