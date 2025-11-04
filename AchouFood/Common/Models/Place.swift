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
    let menu: [MenuCategory]?
}

struct MenuCategory: Decodable {
    let category: String
    let items: [MenuItem]
}

struct MenuItem: Decodable {
    let name: String
    let price: Double
    let imageUrl: String
}
