//
//  Place.swift
//  AchouFood
//
//  Created by Arthur Rios on 04/11/25.
//

import Foundation

public struct Place: Decodable {
    let restaurantID: Int
    let restaurantName: String
    let address: String
    let type: String
    let parkingLot: Bool
    let latitude: Double
    let longitude: Double
    let imageUrl: String
    let description: String
    var menu: [MenuCategory]?
}

struct MenuCategory: Decodable {
    let category: String
    var items: [MenuItem]
}

struct MenuItem: Decodable {
    let name: String
    let price: Double
    let imageUrl: String
    var selectedCount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case name, price, imageUrl
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Double.self, forKey: .price)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        selectedCount = 0
    }
}
