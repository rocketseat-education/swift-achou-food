//
//  PlaceAnnotation.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 11/11/25.
//

import MapKit

final class PlaceAnnotation: NSObject, MKAnnotation {
    let place: Place
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(place: Place) {
        self.place = place
        self.coordinate = CLLocationCoordinate2D(latitude: place.latitude,
                                                 longitude: place.longitude)
        self.title = place.restaurantName
        self.subtitle = place.address
        super.init()
    }
}
