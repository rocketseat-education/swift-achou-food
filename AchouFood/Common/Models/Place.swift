//
//  Place.swift
//  AchouFood
//
//  Created by Arthur Rios on 04/11/25.
//

import Foundation

public struct Place: Decodable {
    let restaurantId: Int
    let restaurantName: String
    let address: String
    let type: String
    let parkingLot: Bool
    let latitude: Double
    let longitude: Double
    let imgUrl: String
    let description: String
    let menu: [MenuCategory]?
}

struct MenuCategory: Decodable {
    let category: String
    let items: [MenuItem]
}

struct MenuItem: Decodable {
    let name: String
    let price: Double
    let imgUrl: String
}
