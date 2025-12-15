//
//  PlaceDetailProtocol.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 13/12/25.
//

import MapKit

protocol PlaceDetailCoordinator: AnyObject {
    func back()
    func showAlert()
    func openMenu(place: Place)
    func traceRoute(_ origin: CLLocationCoordinate2D, _ destiny: CLLocationCoordinate2D)
}
