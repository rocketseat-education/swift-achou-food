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
}

class PlaceDetailView: UIView {
    
    var onBackButtonClicked: (() -> Void)?
    
    private lazy var backButton: UIImageView  = {
        let view = UIImageView()
        view.image = UIImage(named: "backButton")
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
        view.numberOfLines = 5
        return view
    }()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.showsCompass = false
        view.showsScale = false
        return view
    }()

    public init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init decoder has not been implemented")
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
}

extension PlaceDetailView {
    public func setup(place: Place) {
        placeNameLabel.text = place.restaurantName
        placeDescriptionLabel.text = place.description
        loadImage(with: place.imageUrl)
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
    }
    
    func setViewConfigs() {
        backgroundColor = Color.redDark
        contentView.layer.cornerRadius = HomeViewConstants.cornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mapView.layer.cornerRadius = PlaceDetailConstants.mapRadius
        mapView.layer.masksToBounds = true
    }
}
