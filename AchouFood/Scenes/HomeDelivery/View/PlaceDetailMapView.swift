//
//  PlaceDetailMapView.swift
//  AchouFood
//
//  Created by Arthur Rios on 20/12/25.
//

import UIKit
import SnapKit
import Kingfisher

struct PlaceDetailMapViewConstants {
    static let iconSize = 72.0
    static let imagePadding = 12.0
    static let namePadding = 14.0
}

class PlaceDetailMapView: UIView {
    
    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = Color.gray100.cgColor
        return view
    }()
    
    private lazy var placeNameLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleMd
        view.textColor = Color.gray600
        return view
    }()
    
    private lazy var placeAddressLabel: UILabel = {
       let view = UILabel()
        view.font = Typography.bodyXs
        view.textColor = Color.gray500
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            make.top.leading.bottom.equalToSuperview().inset(PlaceDetailMapViewConstants.imagePadding)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(PlaceDetailMapViewConstants.namePadding)
            make.top.trailing.equalToSuperview().inset(PlaceDetailMapViewConstants.namePadding)
        }
        
        placeAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(PlaceDetailMapViewConstants.namePadding)
            make.leading.equalTo(placeImageView.snp.trailing).offset(PlaceDetailMapViewConstants.namePadding)
            make.trailing.equalToSuperview().inset(PlaceDetailMapViewConstants.namePadding)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray200
    }
}
