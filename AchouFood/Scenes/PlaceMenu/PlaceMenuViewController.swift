//
//  PlaceMenuViewController.swift
//  AchouFood
//
//  Created by Arthur Rios on 07/01/26.
//

import UIKit
import SnapKit

class PlaceMenuViewController: UIViewController {
    
    private var placeMenuView: PlaceMenuView
    private var coordinator: PlaceMenuCoordinator
    private var place: Place?
    
    public init(place: Place,
                placeMenuView: PlaceMenuView,
                coordinator: PlaceMenuCoordinator
    ) {
        self.place = place
        self.placeMenuView = placeMenuView
        self.placeMenuView.setup(place: place)
        self.coordinator = coordinator
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
        placeMenuView.resetMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func bindActions() {
        placeMenuView.onBackButtonTapped = { [weak self] in
            self?.coordinator.back()
        }
        
        placeMenuView.showOrder = { [weak self] in
            self?.coordinator.openOrder(place: self?.place)
        }
    }
}

extension PlaceMenuViewController: ViewCodeProtocol {
    func setViewHierarchy() {
        self.view.addSubview(placeMenuView)
    }
    
    func setViewConstraints() {
        
        
        placeMenuView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
