//
//  PlaceMenuFactory.swift
//  AchouFood
//
//  Created by Arthur Rios on 07/01/26.
//

import UIKit

final class PlaceMenuFactory {
    static func make() -> UIViewController {
        let view = PlaceMenuView()
        return PlaceMenuViewController(placeMenuView: view)
    }
}
