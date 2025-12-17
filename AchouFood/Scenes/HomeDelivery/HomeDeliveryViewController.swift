//
//  HomeDeliveryViewController.swift
//  AchouFood
//
//  Created by Arthur Rios on 20/10/25.
//

import UIKit
import SnapKit

class HomeDeliveryViewController: UIViewController {
    
    private var homeView: HomeDeliveryView
    private var viewModel: HomeDeliveryViewModel
    private var coordinator: DeliveryScenesCoordinator
    
    public init(viewModel: HomeDeliveryViewModel,
                homeView: HomeDeliveryView,
                coordinator: DeliveryScenesCoordinator) {
        self.viewModel = viewModel
        self.homeView = homeView
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        buildLayout()
        loadPlaces()
        bindActions()
    }
    
    private func bindActions() {
        homeView.onSelectedPlace = { [weak self] place in
            self?.coordinator.navigateToPlaceDetail(place: place)
        }
    }
}

extension HomeDeliveryViewController {
    func loadPlaces() {
        homeView.startLoading()
        viewModel.fetchPlaces { [weak self] result in
            self?.homeView.stopLoading()
            switch result {
            case .success(let places):
                self?.homeView.setup(with: places)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension HomeDeliveryViewController: ViewCodeProtocol {
    func setViewHierarchy() {
        self.view.addSubview(homeView)
    }
    
    func setViewConstraints() {
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewConfigs() {
        self.view.backgroundColor = Color.redDark
    }
}
