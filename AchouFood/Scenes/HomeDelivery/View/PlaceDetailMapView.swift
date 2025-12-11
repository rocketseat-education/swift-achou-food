//
//  PlaceDetailMapView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 08/12/25.
//

import UIKit
import SnapKit
import Kingfisher

struct PlaceDetailMapViewConstants {
    static let iconSize = 72.0
    static let padding = 20.0
    static let topPlaceIcon = 12.0
    static let topAddressLabel = 4.0
}

class PlaceDetailMapView: UIView {

    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12.0
        view.layer.borderWidth = 2.0
        view.layer.borderColor = Color.gray100.cgColor
        return view
    }()
    
    private lazy var placeNameLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleMd
        view.textColor = Color.gray500
        return view
    }()
    
    private lazy var placeAddressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodyXs
        view.textColor = Color.gray400
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init decoder has not been implemented")
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

extension PlaceDetailMapView {
    public func setup(place: Place) {
        placeNameLabel.text = place.restaurantName
        placeAddressLabel.text = place.address
        loadImage(with: place.imageUrl)
    }
}

extension PlaceDetailMapView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(placeImageView)
        addSubview(placeNameLabel)
        addSubview(placeAddressLabel)
    }
    
    func setViewConstraints() {
        placeImageView.snp.makeConstraints { make in
            make.size.equalTo(PlaceDetailMapViewConstants.iconSize)
            make.top.leading.equalToSuperview().inset(PlaceDetailMapViewConstants.topPlaceIcon)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(PlaceDetailMapViewConstants.padding)
            make.top.trailing.equalToSuperview().offset(PlaceDetailMapViewConstants.padding)
        }
        
        placeAddressLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(PlaceDetailMapViewConstants.padding)
            make.top.equalTo(placeNameLabel.snp.bottom).offset(PlaceDetailMapViewConstants.topAddressLabel)
            make.trailing.equalToSuperview().inset(PlaceDetailMapViewConstants.padding)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray200
    }
}
