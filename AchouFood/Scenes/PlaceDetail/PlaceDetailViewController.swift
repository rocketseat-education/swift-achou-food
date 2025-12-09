//
//  PlaceDetailViewController.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 08/12/25.
//

import UIKit
import SnapKit

class PlaceDetailViewController: UIViewController {
    
    private var placeModel: Place
    private var placeDetailView: PlaceDetailView
    private var coordinator: PlaceMenuCoordinatorProtocol

    public init(placeModel: Place,
                placeDetailView: PlaceDetailView,
                coordinator: PlaceMenuCoordinatorProtocol) {
        self.placeModel = placeModel
        self.placeDetailView = placeDetailView
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        buildLayout()
        bindActions()
    }
    
    private func bindActions() {
        placeDetailView.onBackButtonClicked = { [weak self] in
            self?.coordinator.back()
        }
    }
}

extension PlaceDetailViewController: ViewCodeProtocol {
    func setViewHierarchy() {
        view.addSubview(placeDetailView)
    }
    
    func setViewConstraints() {
        placeDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewConfigs() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = Color.redDark
        self.navigationItem.hidesBackButton = true
    }
}
