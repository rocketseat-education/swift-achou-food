//
//  OrderViewController.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 28/01/26.
//

import UIKit
import SnapKit

class OrderViewController: UIViewController {
    
    private var orderView: OrderView
    private var coodinator: OrderCoordinator
    var place: Place?
    
    public init(orderView: OrderView,
                coordinator: OrderCoordinator) {
        self.orderView = orderView
        self.coodinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        bindActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        orderView.setup(place: self.place)
    }
    
    func bindActions() {
        orderView.emptyOrderButtonTapped = { [weak self] in
            self?.coodinator.openMenu()
        }
    }
}

extension OrderViewController {
    public func setPlace(place: Place?) {
        self.place = place
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
