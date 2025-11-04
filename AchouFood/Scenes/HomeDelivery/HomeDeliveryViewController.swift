//
//  HomeDeliveryViewController.swift
//  AchouFood
//
//  Created by Arthur Rios on 20/10/25.
//

import UIKit

class HomeDeliveryViewController: UIViewController {
    
    private var homeDeliveryView: HomeDeliveryView?
    
    override func loadView() {
        self.homeDeliveryView = HomeDeliveryView()
        self.view = self.homeDeliveryView
        let service = HomeDeliveryServiceMock()
        service.fetchPlaces { result in
            switch (result) {
            case let .success(places):
                print(places)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
