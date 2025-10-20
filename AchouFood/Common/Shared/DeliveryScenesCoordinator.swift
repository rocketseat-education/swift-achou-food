//
//  DeliveryScenesCoordinator.swift
//  AchouFood
//
//  Created by Arthur Rios on 20/10/25.
//

import UIKit

class DeliveryScenesCoordinator {
    private var navigationController: UINavigationController?
    
    func start() -> UINavigationController? {
        self.navigationController = UINavigationController(rootViewController: HomeDeliveryViewController())
        
        return self.navigationController
    }
}
