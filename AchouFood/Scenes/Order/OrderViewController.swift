//
//  OrderViewController.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 24/01/26.
//

import UIKit
import SnapKit

class OrderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
