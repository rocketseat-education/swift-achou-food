//
//  PlaceAnnotation.swift
//  AchouFood
//
//  Created by Arthur Rios on 24/11/25.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let place: Place
    let title: String?
    let subtitle: String?
    
    init(place: Place) {
        self.place = place
        self.title = place.restaurantName
        self.subtitle = place.address
        self.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        super.init()
    }
}
