//
//  PlaceDetailButtons.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 14/12/25.
//

import UIKit
import SnapKit

struct PlaceDetailButtonsConstants {
    static let padding = 20
    static let routeImage = "routeIcon"
    static let menuImage = "menuIcon"
    static let horizontalPadding = 16.0
    static let bottomPadding = 10.0
    static let buttonHeight = 44.0
    static let centerOffset = 8.0
    static let cornerRadius = 20.0
    static let borderWith = 1.0
}

class PlaceDetailButtons: UIView {
    
    var onTraceRouteTapped: (() -> Void)?
    var onMenuTapped: (() -> Void)?
    
    private lazy var placeNameLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray600
        return view
    }()
    
    private lazy var placeAddressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray600
        view.numberOfLines = 2
        return view
    }()
    
    private lazy var placeInfoLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray600
        return view
    }()
    
    private lazy var routeButton: UIButton = {
        let view = UIButton()
        view.setTitle("Traçar Rota", for: .normal)
        view.setTitleColor(Color.gray500, for: .normal)
        view.titleLabel?.font = Typography.bodyXs
        view.addTarget(self, action: #selector(handleTraceRoute), for: .touchUpInside)
        view.setImage(UIImage(named: PlaceDetailButtonsConstants.routeImage), for: .normal)
        return view
    }()
    
    private lazy var menuButton: UIButton = {
        let view = UIButton()
        view.setTitle("Ver Cardápio", for: .normal)
        view.setTitleColor(Color.redBase, for: .normal)
        view.titleLabel?.font = Typography.bodyXs
        view.addTarget(self, action: #selector(handleOpenMenu), for: .touchUpInside)
        view.setImage(UIImage(named: PlaceDetailButtonsConstants.menuImage), for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func handleTraceRoute() {
        onTraceRouteTapped?()
    }
    
    @objc
    func handleOpenMenu() {
        onMenuTapped?()
    }
}

extension PlaceDetailButtons {
    public func setup(place: Place) {
        placeNameLabel.text = place.restaurantName
        placeAddressLabel.text = place.address
        placeInfoLabel.text = place.type
    }
}

extension PlaceDetailButtons: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(placeNameLabel)
        addSubview(placeAddressLabel)
        addSubview(placeInfoLabel)
        addSubview(routeButton)
        addSubview(menuButton)
    }
    
    func setViewConstraints() {
        placeNameLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(PlaceDetailButtonsConstants.padding)
        }
        
        placeAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(PlaceDetailButtonsConstants.padding)
        }
        
        placeInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(placeAddressLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(PlaceDetailButtonsConstants.padding)
        }
        
        routeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(PlaceDetailButtonsConstants.horizontalPadding)
            make.trailing.equalTo(self.snp.centerX).offset(-PlaceDetailButtonsConstants.centerOffset)
            make.bottom.equalToSuperview().inset(PlaceDetailButtonsConstants.bottomPadding)
            make.height.equalTo(PlaceDetailButtonsConstants.buttonHeight)
        }
        
        menuButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(PlaceDetailButtonsConstants.horizontalPadding)
            make.leading.equalTo(self.snp.centerX).offset(PlaceDetailButtonsConstants.centerOffset)
            make.bottom.equalToSuperview().inset(PlaceDetailButtonsConstants.bottomPadding)
            make.height.equalTo(PlaceDetailButtonsConstants.buttonHeight)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.grayTransparent80p
        routeButton.layer.masksToBounds = true
        routeButton.layer.cornerRadius = PlaceDetailButtonsConstants.cornerRadius
        routeButton.layer.borderWidth = PlaceDetailButtonsConstants.borderWith
        routeButton.layer.borderColor = Color.gray100.cgColor
        menuButton.layer.masksToBounds = true
        menuButton.layer.cornerRadius = PlaceDetailButtonsConstants.cornerRadius
        menuButton.layer.borderWidth = PlaceDetailButtonsConstants.borderWith
        menuButton.layer.borderColor = Color.gray100.cgColor
    }
}
