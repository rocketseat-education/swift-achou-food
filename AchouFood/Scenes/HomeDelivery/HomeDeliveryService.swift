//
//  HomeDeliveryService.swift
//  AchouFood
//
//  Created by Arthur Rios on 04/11/25.
//

import Foundation

public typealias FetchPlacesCompletion = (Result<[Place]?, Error>) -> Void

public protocol HomeDeliveryService {
    func fetchPlaces(completion: @escaping FetchPlacesCompletion)
}

final class HomeDeliveryServiceMock: HomeDeliveryService {
    func fetchPlaces(completion: @escaping FetchPlacesCompletion) {
        let places = self.loadMockPlaces()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            if let places = places {
                completion(.success(places))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
    private func loadMockPlaces() -> [Place]? {
        guard let url = Bundle.main.url(forResource: "places", withExtension: "json") else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let places = try? decoder.decode([Place].self, from: data)
        
        return places
    }
}
