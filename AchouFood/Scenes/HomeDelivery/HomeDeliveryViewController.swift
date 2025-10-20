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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
