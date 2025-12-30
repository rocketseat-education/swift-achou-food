//
//  PlaceMenuFactory.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 26/12/25.
//

import UIKit

final class PlaceMenuFactory {
    static func make(place: Place, coordinator: PlaceMenuCoordinator) -> UIViewController {
        let view = PlaceMenuView()
        return PlaceMenuViewController(placeModel: place,
                                       placeMenuView: view,
                                       coordinator: coordinator)
    }
}
