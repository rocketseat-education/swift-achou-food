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
    
    public init(placeMenuView: PlaceMenuView,
                coordinator: PlaceMenuCoordinator
    ) {
        self.placeMenuView = placeMenuView
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
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func bindActions() {
        placeMenuView.onBackButtonTapped = { [weak self] in
            self?.coordinator.back()
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
