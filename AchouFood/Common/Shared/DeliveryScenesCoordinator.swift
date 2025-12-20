//
//  DeliveryScenesCoordinator.swift
//  AchouFood
//
//  Created by Arthur Rios on 20/10/25.
//

import UIKit

public class DeliveryScenesCoordinator {
    private var navigationController: UINavigationController?
    
    // MARK: - Start
    func start() -> UINavigationController? {
        let homeDeliveryViewController = HomeDeliveryFactory.make(coordinator: self)
        self.navigationController = homeDeliveryViewController
        
        return self.navigationController
    }
}

extension DeliveryScenesCoordinator: PlaceDetailCoordinatorProtocol {
    public func navigateToPlaceDetail(place: Place) {
        let viewController = PlaceDetailFactory.make(place: place, coordinator: self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
