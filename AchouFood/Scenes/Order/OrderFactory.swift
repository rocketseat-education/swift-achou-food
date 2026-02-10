//
//  OrderFactory.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 28/01/26.
//

import UIKit

public class OrderFactory {
    static func make(coordinator: OrderCoordinator) -> UIViewController {
        let view = OrderView()
        return OrderViewController(orderView: view,
                                   coordinator: coordinator)
    }
}
