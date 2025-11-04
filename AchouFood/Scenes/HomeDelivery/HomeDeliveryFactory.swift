//
//  HomeDeliveryFactory.swift
//  AchouFood
//
//  Created by Arthur Rios on 04/11/25.
//

import UIKit

final class HomeDeliveryFactory {
    static func make(coordinator: DeliveryScenesCoordinator) -> UINavigationController {
        let service = HomeDeliveryServiceMock()
        let viewModel = HomeDeliveryViewModel(service: service)
        let view = HomeDeliveryView()
        let viewController = HomeDeliveryViewController(viewModel: viewModel,
                                          homeView: view,
                                          coordinator: coordinator)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
