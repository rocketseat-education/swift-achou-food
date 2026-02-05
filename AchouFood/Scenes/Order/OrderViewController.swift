//
//  OrderViewController.swift
//  AchouFood
//
//  Created by Arthur Rios on 05/02/26.
//

import UIKit
import SnapKit

final class OrderViewController: UIViewController {
    
    private var orderView: OrderView
    private var coordinator: OrderCoordinator?
    var place: Place?
    
    init(
        orderView: OrderView,
        coordinator: OrderCoordinator
    ) {
        self.orderView = orderView
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
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
    
    func setViewConfigs() {
    }
}
