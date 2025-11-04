//
//  HomeDeliveryViewModel.swift
//  AchouFood
//
//  Created by Arthur Rios on 04/11/25.
//

class HomeDeliveryViewModel {
    let homeDeliveryService: HomeDeliveryService
    
    public init(service: HomeDeliveryService) {
        self.homeDeliveryService = service
    }
    
    public func fetchPlaces(completion: @escaping FetchPlacesCompletion) {
        homeDeliveryService.fetchPlaces { result in
            completion(result)
        }
    }
}
