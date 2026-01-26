//
//  OrderFactory.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 25/01/26.
//

import UIKit

final class OrderFactory {
    static func make(coordinator: OrderCoordinator) -> UIViewController {
        let view = OrderView()
        return OrderViewController(orderView: view,
                                   coordinator: coordinator)
    }
}
