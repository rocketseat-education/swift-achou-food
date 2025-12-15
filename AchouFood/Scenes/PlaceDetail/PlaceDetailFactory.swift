//
//  PlaceDetailFactory.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 12/12/25.
//

import UIKit

final class PlaceDetailFactory {
    static func make(place: Place, coordinator: DeliveryScenesCoordinator) -> UIViewController {
        let view = PlaceDetailView()
        return PlaceDetailViewController(placeModel: place,
                                         placeDetailView: view,
                                         coordinator: coordinator)
    }
}
