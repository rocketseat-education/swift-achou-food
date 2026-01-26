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
    private var tabBarController: UITabBarController?
    
    // MARK: - Start
    func start() -> UITabBarController? {
        return createTabBar()
    }
    
    private func createTabBar() -> UITabBarController {
        tabBarController = UITabBarController()
        tabBarController?.tabBar.tintColor = Color.redBase
        tabBarController?.tabBar.unselectedItemTintColor = Color.gray500

        let homeNav = HomeDeliveryFactory.make(coordinator: self)
        navigationController = homeNav
        homeNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "menu"),
            selectedImage: UIImage(named: "menu")
        )

        let orderVC = OrderFactory.make(coordinator: self)
        let orderNav = UINavigationController(rootViewController: orderVC)
        orderNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "order"),
            selectedImage: UIImage(named: "order")
        )

        tabBarController?.viewControllers = [homeNav, orderNav]
        return tabBarController ??  UITabBarController()
    }
}

// MARK: - HomeDelivery Coordinator
extension DeliveryScenesCoordinator: HomeDeliveryCoordinator {
    public func navigateToPlaceDetail(place: Place) {
        let viewController = PlaceDetailFactory.make(place: place, coordinator: self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - PlaceDetail Coordinator
extension DeliveryScenesCoordinator: PlaceDetailCoordinator {
    public func traceRoute(_ origin: CLLocationCoordinate2D, _ destination: CLLocationCoordinate2D) {
        let originPlacemark = MKPlacemark(coordinate: origin)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let originItem = MKMapItem(placemark: originPlacemark)
        originItem.name = "Você"
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        destinationItem.name = "Destino"
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                              MKLaunchOptionsShowsTrafficKey: true] as [String : Any]
        MKMapItem.openMaps(with: [originItem, destinationItem], launchOptions: launchOptions)
    }
    
    public func showAlert() {
        let alert = UIAlertController(title: "alert.title".localized, message: "alert.message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alert.cancel".localized, style: .cancel))
        alert.addAction(UIAlertAction(title: "alert.settings".localized, style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        
        navigationController?.present(alert, animated: true)
    }
    
    public func back() {
        navigationController?.popViewController(animated: true)
    }
    
    public func openMenu(place: Place) {
        let viewController = PlaceMenuFactory.make(place: place, coordinator: self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - PlaceMenu Coordinator
extension DeliveryScenesCoordinator: PlaceMenuCoordinator {
    public func openOrder() {
        tabBarController?.selectedIndex = 1
    }
}

// MARK: - Order Coordinator
extension DeliveryScenesCoordinator: OrderCoordinator {
    public func openMenu(place: Place?) {
        if place != nil {
            let orderController = tabBarController?.viewControllers?[1] as? OrderViewController
            if orderController != nil {
                orderController?.place = place
            }
        }
        tabBarController?.selectedIndex = 0
    }
}



