//
//  DeliveryScenesCoordinator.swift
//  AchouFood
//
//  Created by Arthur Rios on 20/10/25.
//

import UIKit

public class DeliveryScenesCoordinator {
    private var navigationController: UINavigationController?
    
    func start() -> UINavigationController? {
        let homeDeliveryViewController = HomeDeliveryFactory.make(coordinator: self)
        self.navigationController = homeDeliveryViewController
        
        return self.navigationController
    }
}

//MARK: - Place Detail
extension DeliveryScenesCoordinator: PlaceDetailCoordinatorProtocol {
    public func navigateToPlaceDetail(place: Place) {
        let placeDetailViewController = PlaceDetailFactory.make(place: place, coordinator: self)
        navigationController?.pushViewController(placeDetailViewController,
                                                 animated: true)
    }
}

//MARK: - Place Menu
extension DeliveryScenesCoordinator: PlaceMenuCoordinatorProtocol {
    public func navigateToPlaceMenu(place: Place) {
    }
    
    public func back() {
        navigationController?.popViewController(animated: true)
    }
}
