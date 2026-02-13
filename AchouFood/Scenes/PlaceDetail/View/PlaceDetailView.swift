//
//  PlaceDetailView.swift
//  AchouFood
//
//  Created by Arthur Rios on 17/12/25.
//

import CoreLocation
import Kingfisher
import MapKit
import SnapKit
import UIKit

struct PlaceDetailConstants {
    static let backButtonImage = "backButton"
    static let padding = 20.0
    static let backImageSize = 36.0
    static let contentTop = 153.0
    static let topImagePadding = 93.0
    static let mapViewTopPadding = 32.0
    static let mapViewRadius = 20.0
    static let placeImageSize = 80.0
    static let buttonsHeight = 162.0
    static let buttonsRadius = 18.0
    static let buttonsBorderWidth = 1.5
}

class PlaceDetailView: UIView {
    
    var onBackButtonTapped: (() -> Void)?
    var presentAlert: (() -> Void)?
    var onTraceRoute: ((CLLocationCoordinate2D, CLLocationCoordinate2D) -> Void)?
    var onMenuTapped: (() -> Void)?
    var place: Place?
    
    private lazy var backButton: UIImageView = {
        let view = UIImageView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        view.image = UIImage(named: PlaceDetailConstants.backButtonImage)
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.masksToBounds = true
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 4
        view.layer.borderColor = Color.gray100.cgColor
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleLg
        view.textColor = Color.gray600
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray500
        view.numberOfLines = 5
        return view
    }()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.showsCompass = false
        view.showsScale = false
        view.delegate = self
        return view
    }()
    
    let placeDetailButtons: PlaceDetailButtons = {
        let view = PlaceDetailButtons()
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray100
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        buildLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backButton.layer.cornerRadius = backButton.frame.height / 2
    }
    
    @objc
    private func handleBack() {
        onBackButtonTapped?()
    }
    
    private func showPlaceOnMap(_ place: Place) {
        let coords = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        let pin = MKPointAnnotation()
        pin.coordinate = coords
        pin.title = place.restaurantName
        mapView.addAnnotation(pin)
        let region = MKCoordinateRegion(
            center: coords,
            latitudinalMeters: 1500,
            longitudinalMeters: 1500)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(pin, animated: true)
    }
    
    private func bindActions() {
        placeDetailButtons.onTraceRouteTapped = { [weak self] in
            self?.verifyUserPermission()
        }
        
        placeDetailButtons.onMenuTapped = { [weak self] in
            self?.onMenuTapped?()
        }
    }
    
    private func traceRoute() {
        guard let place = place else { return }
        let locationManager = CLLocationManager()
        let dest = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        let source = locationManager.location?.coordinate
        print(source)
        if let source = source {
            onTraceRoute?(source, dest)
        }
    }
    
    private func verifyUserPermission() {
        let locationManager = CLLocationManager()
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            traceRoute()
        case .denied, .restricted:
            // Disparar um alerta
            presentAlert?()
        @unknown default:
            break
        }
        
    }
}

extension PlaceDetailView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(backButton)
        addSubview(contentView)
        addSubview(placeImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(mapView)
        addSubview(placeDetailButtons)
    }
    
    func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Metrics.medium)
            make.leading.equalToSuperview().offset(PlaceDetailConstants.padding)
            make.size.equalTo(PlaceDetailConstants.backImageSize)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(PlaceDetailConstants.contentTop)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        placeImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(PlaceDetailConstants.topImagePadding)
            make.leading.equalToSuperview().inset(PlaceDetailConstants.mapViewRadius)
            make.size.equalTo(PlaceDetailConstants.placeImageSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(placeImageView.snp.bottom).offset(PlaceDetailConstants.mapViewRadius)
            make.leading.trailing.equalToSuperview().inset(PlaceDetailConstants.mapViewRadius)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metrics.small)
            make.leading.trailing.equalToSuperview().inset(PlaceDetailConstants.mapViewRadius)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(PlaceDetailConstants.mapViewTopPadding)
            make.leading.trailing.bottom.equalToSuperview().inset(PlaceDetailConstants.mapViewRadius)
        }
        
        placeDetailButtons.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(mapView).inset(Metrics.tiny)
            make.height.equalTo(PlaceDetailConstants.buttonsHeight)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.redDark
        contentView.layer.cornerRadius = Metrics.medium
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.layer.masksToBounds = true
        mapView.layer.cornerRadius = PlaceDetailConstants.mapViewRadius
        mapView.layer.masksToBounds = true
        placeDetailButtons.layer.masksToBounds = true
        placeDetailButtons.layer.cornerRadius = PlaceDetailConstants.buttonsRadius
        placeDetailButtons.layer.borderWidth = PlaceDetailConstants.buttonsBorderWidth
        placeDetailButtons.layer.borderColor = Color.gray100.cgColor
    }
}

extension PlaceDetailView {
    public func setup(place: Place) {
        self.place = place
        titleLabel.text = place.restaurantName
        descriptionLabel.text = place.description
        placeImageView.loadImage(from: place.imageUrl)
        placeDetailButtons.setup(place: place)
        showPlaceOnMap(place)
    }
}

extension PlaceDetailView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let view =
        mapView.dequeueReusableAnnotationView(withIdentifier: MapViewConstants.placeId)
        ?? MKAnnotationView(annotation: annotation, reuseIdentifier: MapViewConstants.placeId)
        view.annotation = annotation
        view.canShowCallout = false
        view.image = UIImage(named: MapViewConstants.redPin)
        return view
    }
}
