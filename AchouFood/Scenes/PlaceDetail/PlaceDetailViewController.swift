//
//  PlaceDetailViewController.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 12/12/25.
//

import UIKit
import SnapKit

class PlaceDetailViewController: UIViewController {
    
    private var place: Place
    private var placeDetailView: PlaceDetailView
    private var coordinator: PlaceDetailCoordinator
    
    public init(placeModel: Place,
                placeDetailView: PlaceDetailView,
                coordinator: PlaceDetailCoordinator) {
        self.place = placeModel
        self.placeDetailView = placeDetailView
        self.placeDetailView.setup(place: place)
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func bindActions() {
        placeDetailView.onBackButtonClicked = { [weak self] in
            self?.coordinator.back()
        }
        
        placeDetailView.presentAlert = { [weak self] in
            self?.coordinator.showAlert()
        }
        
        placeDetailView.presentRoute = { [weak self] origin, destiny in
            self?.coordinator.traceRoute(origin, destiny)
        }
    }
}

extension PlaceDetailViewController: ViewCodeProtocol {
    func setViewHierarchy() {
        self.view.addSubview(placeDetailView)
    }
    
    func setViewConstraints() {
        placeDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewConfigs() {
    }
}
