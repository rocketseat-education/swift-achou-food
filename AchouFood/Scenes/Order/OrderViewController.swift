//
//  OrderViewController.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 24/01/26.
//

import UIKit
import SnapKit

class OrderViewController: UIViewController {
    
    let orderView = OrderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension OrderViewController: ViewCodeProtocol {
    func setViewHierarchy() {
        view.addSubview(orderView)
    }
    
    func setViewConstraints() {
        orderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
