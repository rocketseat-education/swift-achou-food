//
//  PlaceDetailView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 08/12/25.
//

import UIKit
import SnapKit
import MapKit
import Kingfisher
import CoreLocation

struct PlaceDetailConstants {
    static let backButtonSize = 36.0
    static let borderWidth = 2.0
    static let borderPadding = 20.0
    static let placeImageSize = 80.0
    static let topImagePadding = 93.0
    static let topContentPadding = 153.0
    static let mapRadius = 20.0
    static let mapViewTopPadding = 32.0
    static let placeImageRadius = 16.0
    static let placeImageBorderWidth = 4.0
    static let buttonsViewHeight = 162.0
    static let alertTitle = "alertTitle.permission".localized
    static let alertMessage = "alertMessage".localized
    static let buttonCancel = "alertButton.cancel".localized
    static let buttonSettings = "alertButton.settings".localized
    static let mapSource = "map.source".localized
    static let mapDestiny = "map.destiny".localized
    static let backButton = "backButton"
}

class PlaceDetailView: UIView {
    
    var onBackButtonClicked: (() -> Void)?
    var onMenuButtonClicked: (() -> Void)?
    var presentAlert: (() -> Void)?
    var place: Place?
    private let locationManager = CLLocationManager()
    private var onAuthorized: (() -> Void)?
    
    private lazy var backButton: UIImageView  = {
        let view = UIImageView()
        view.image = UIImage(named: PlaceDetailConstants.backButton)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (handleBack))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = PlaceDetailConstants.borderWidth
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray100
        return view
    }()
    
    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = PlaceDetailConstants.placeImageRadius
        view.layer.borderWidth = PlaceDetailConstants.placeImageBorderWidth
        view.layer.borderColor = Color.gray100.cgColor
        return view
    }()
    
    private lazy var placeNameLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleLg
        view.textColor = Color.gray600
        return view
    }()
    
    private lazy var placeDescriptionLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray500
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.showsCompass = false
        view.showsScale = false
        view.delegate = self
        return view
    }()
    
    private lazy var buttonsView: PlaceDetailButtonsView = {
        let view = PlaceDetailButtonsView()
        return view
    }()

    public init() {
        super.init(frame: .zero)
        buildLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init decoder has not been implemented")
    }
    
    private func destinationCoordinate(from place: Place) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: place.latitude,
            longitude: place.longitude
        )
    }
    
    private func bindActions() {
        buttonsView.onTraceRouteTapped = { [weak self] in
            guard let self, let place = self.place else { return }
            let destiny = destinationCoordinate(from: place)
            self.openRouteInAppleMaps(to: destiny)
        }
        buttonsView.onMenuTapped = { [weak self] in
            self?.onMenuButtonClicked?()
        }
    }
    
    @objc
    private func handleBack() {
        onBackButtonClicked?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backButton.layer.cornerRadius = backButton.frame.height / 2
    }
    
    private func loadImage(with urlString: String) {
        if let url = URL(string: urlString) {
            placeImageView.kf.setImage(with: url,
                                       placeholder: UIImage(systemName: "photo"),
                                       options: [.transition(.fade(0.3))]
            )
        }
    }
    
    private func showPlaceOnMap(_ place: Place) {
        let coord = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        let old = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.removeAnnotations(old)
        let pin = MKPointAnnotation()
        pin.coordinate = coord
        pin.title = place.restaurantName
        mapView.addAnnotation(pin)
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(pin, animated: true)
    }
    
    private func openRouteInAppleMaps(to destinationCoordinate: CLLocationCoordinate2D) {
        handleLocationAccess {
            guard let sourceCoordinate = self.locationManager.location?.coordinate else { return }
            self.openLocationScreen(sourceCoordinate, destinationCoordinate)
        }
    }
    
    private func handleLocationAccess(onAuthorized: @escaping () -> Void) {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            onAuthorized()

        case .denied, .restricted:
            presentAlert?()

        @unknown default:
            break
        }
    }
        
    private func openLocationScreen(_ sourceCoordinate: CLLocationCoordinate2D,
                                    _ destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        sourceItem.name = PlaceDetailConstants.mapSource
        
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        destinationItem.name = PlaceDetailConstants.mapDestiny
        
        let options = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsShowsTrafficKey: true
        ] as [String : Any]
        
        MKMapItem.openMaps(with: [sourceItem, destinationItem], launchOptions: options)
    }
}

extension PlaceDetailView {
    public func setup(place: Place) {
        self.place = place
        buttonsView.setup(place: place)
        placeNameLabel.text = place.restaurantName
        placeDescriptionLabel.text = place.description
        loadImage(with: place.imageUrl)
        showPlaceOnMap(place)
    }
}

extension PlaceDetailView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(backButton)
        addSubview(contentView)
        addSubview(placeImageView)
        addSubview(placeNameLabel)
        addSubview(placeDescriptionLabel)
        addSubview(mapView)
        mapView.addSubview(buttonsView)
    }
    
    func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Metrics.medium)
            make.leading.equalToSuperview().offset(Metrics.medium)
            make.size.equalTo(PlaceDetailConstants.backButtonSize)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(PlaceDetailConstants.topContentPadding)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        placeImageView.snp.makeConstraints { make in
            make.size.equalTo(PlaceDetailConstants.placeImageSize)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(PlaceDetailConstants.topImagePadding)
            make.leading.equalTo(PlaceDetailConstants.borderPadding)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(placeImageView.snp.bottom).offset(PlaceDetailConstants.borderPadding)
            make.leading.trailing.equalToSuperview().inset(PlaceDetailConstants.borderPadding)
        }
        
        placeDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(Metrics.small)
            make.leading.trailing.equalToSuperview().inset(PlaceDetailConstants.borderPadding)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(placeDescriptionLabel.snp.bottom).offset(PlaceDetailConstants.mapViewTopPadding)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(PlaceDetailConstants.borderPadding)
        }
        
        buttonsView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(Metrics.tiny)
            make.height.equalTo(PlaceDetailConstants.buttonsViewHeight)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.redDark
        contentView.layer.cornerRadius = HomeViewConstants.cornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mapView.layer.cornerRadius = PlaceDetailConstants.mapRadius
        mapView.layer.masksToBounds = true
        buttonsView.layer.masksToBounds = true
        buttonsView.layer.cornerRadius = PlaceDetailConstants.mapRadius
        buttonsView.layer.borderWidth = PlaceDetailConstants.borderWidth
        buttonsView.layer.borderColor = Color.gray100.cgColor
    }
}

extension PlaceDetailView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: MapViewConstants.placeId) ??
        MKAnnotationView(annotation: annotation, reuseIdentifier: MapViewConstants.placeId)
        view.annotation = annotation
        view.canShowCallout = false
        view.image = UIImage(named: MapViewConstants.redPin)
        return view
    }
}
