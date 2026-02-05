//
//  OrderFactory.swift
//  AchouFood
//
//  Created by Arthur Rios on 05/02/26.
//

import UIKit

public class OrderFactory {
    static func make(coordinator: OrderCoordinator) -> UIViewController {
        let view = OrderView()
        return OrderViewController(
            orderView: view,
            coordinator: coordinator
        )
    }
}
