//
//  OrderManager.swift
//  AchouFood
//
//  Created by Arthur Rios on 25/01/26.
//

import Foundation

class OrderManager {
    public static var shared = OrderManager()
    private var items: [String : MenuItem] = [:]
    
    private init() {}
    
    public func setItem(menuItem: MenuItem) {
        if (menuItem.selectedCount > 0) {
            items[menuItem.name] = menuItem
            return
        }
        items.removeValue(forKey: menuItem.name)
    }
    
    public func qttItems() -> String {
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
    
    public func clear() {
        items.removeAll()
    }
}
