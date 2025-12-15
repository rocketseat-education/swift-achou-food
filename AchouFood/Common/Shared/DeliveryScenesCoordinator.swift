//
//  DeliveryScenesCoordinator.swift
//  AchouFood
//
//  Created by Arthur Rios on 20/10/25.
//

import UIKit
import MapKit

public class DeliveryScenesCoordinator {
    private var navigationController: UINavigationController?
    
    //MARK: - Start
    func start() -> UINavigationController? {
        let homeDeliveryViewController = HomeDeliveryFactory.make(coordinator: self)
        self.navigationController = homeDeliveryViewController
        
        return self.navigationController
    }
}

//MARK - HomeDelivery Coordinator
extension DeliveryScenesCoordinator: HomeDeliveryCoordinator {
    public func navigateToPlaceDetail(place: Place) {
        let viewController = PlaceDetailFactory.make(place: place, coordinator: self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK - PlaceDetail Coordinator
extension DeliveryScenesCoordinator: PlaceDetailCoordinator {
    func traceRoute(_ origin: CLLocationCoordinate2D, _ destiny: CLLocationCoordinate2D) {
        let originPlacemark = MKPlacemark(coordinate: origin)
        let destinationPlacemark = MKPlacemark(coordinate: destiny)
        let originItem = MKMapItem(placemark: originPlacemark)
        originItem.name = "Você"
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        destinationItem.name = "Destino"
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                               MKLaunchOptionsShowsTrafficKey: true] as [String : Any]
        MKMapItem.openMaps(with: [originItem, destinationItem], launchOptions: launchOptions)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "alert.title".localized,
                                      message: "alert.message".localized,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alert.cancel".localized, style: .cancel))
        alert.addAction(UIAlertAction(title: "alert.settings".localized, style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        navigationController?.present(alert, animated: true)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func openMenu(place: Place) {
    }
}
