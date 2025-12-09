//
//  PlaceDetailFactory.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 08/12/25.
//

import UIKit

final class PlaceDetailFactory {
    static func make(place: Place, coordinator: PlaceMenuCoordinatorProtocol) -> UIViewController {
        let view = PlaceDetailView()
        return PlaceDetailViewController(placeModel: place,
                                         placeDetailView: view,
                                         coordinator: coordinator)
    }
}
