//
//  OrderManager.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 04/01/26.
//

import Foundation

class OrderManager {
    public static var shared = OrderManager()
    private var items: [String : MenuItem] = [:]
    
    private init(){}
    
    public func setItem(menuItem: MenuItem) {
        if menuItem.selectedCount > 0 {
            items[menuItem.name] = menuItem
            return
        }
        items.removeValue(forKey: menuItem.name)
    }
    
    public func qtdItens() -> String {
        var count = 0
        for item in items.values {
            count += item.selectedCount
        }
        return "\(count) ITENS"
    }
    
    public func totalOrder() -> String {
        var total = 0.0
        for item in items.values {
            total += Double(item.selectedCount) * item.price
        }
        return String(format: "R$ %.2f", total)
    }
}
