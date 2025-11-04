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
