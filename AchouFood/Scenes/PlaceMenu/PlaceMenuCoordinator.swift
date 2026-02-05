//
//  PlaceMenuCoordinatorProtocol.swift
//  AchouFood
//
//  Created by Arthur Rios on 07/01/26.
//

public protocol PlaceMenuCoordinator: AnyObject {
    func back()
    func openOrder(place: Place?)
}
