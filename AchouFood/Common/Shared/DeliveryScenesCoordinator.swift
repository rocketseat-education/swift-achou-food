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
        // Criar a ViewController com factory
        // navegar para próxima tela com o NavigationController
        print("Chamando Tela de Detalhes")
    }
}
