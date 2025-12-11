//
//  PlaceDetailViewController.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 08/12/25.
//

import UIKit
import SnapKit

class PlaceDetailViewController: UIViewController {
    
    private var place: Place
    private var placeDetailView: PlaceDetailView
    private var coordinator: PlaceMenuCoordinatorProtocol

    public init(placeModel: Place,
                placeDetailView: PlaceDetailView,
                coordinator: PlaceMenuCoordinatorProtocol) {
        self.place = placeModel
        self.placeDetailView = placeDetailView
        self.placeDetailView.setup(place: placeModel)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: PlaceDetailConstants.alertTitle,
                                      message: PlaceDetailConstants.alertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: PlaceDetailConstants.buttonCancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: PlaceDetailConstants.buttonSettings,
                                      style: .default,
        handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
        return alert
    }
    
    private func bindActions() {
        placeDetailView.onBackButtonClicked = { [weak self] in
            self?.coordinator.back()
        }
        
        placeDetailView.onMenuButtonClicked = { [weak self] in
            if let place = self?.place {
                self?.coordinator.navigateToPlaceMenu(place: place)
            }
        }
        
        placeDetailView.presentAlert = { [weak self] in
            guard let self = self else { return }
            self.present(self.createAlert(), animated: true, completion: nil)
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
