//
//  PlaceDetailButtonsView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 10/12/25.
//

import UIKit
import SnapKit

struct PlaceDetailButtonsConstants {
    static let padding = 16.0
    static let buttonHeight = 44.0
    static let cornerRadius = 20.0
    static let borderWidth = 2.0
    static let routeLabel = "placeDetail.button.route"
    static let menuLabel = "placeDetail.button.menu"
}

class PlaceDetailButtonsView: UIView {
    
    public var onTraceRouteTapped: (() -> Void)?
    public var onMenuTapped: (() -> Void)?
    
    private lazy var placeNameLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray600
        view.numberOfLines = 2
        return view
    }()
    
    private lazy var placeAddressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray600
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var placeInfoLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray600
        return view
    }()
    
    private lazy var traceRouteButton: UIButton = {
        let view = UIButton()
        view.setTitle(PlaceDetailButtonsConstants.routeLabel.localized, for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = Color.gray100
        view.addTarget(self, action: #selector(handleTraceRoute), for: .touchUpInside)
        return view
    }()
    
    private lazy var menuButton: UIButton = {
        let view = UIButton()
        view.setTitle(PlaceDetailButtonsConstants.menuLabel.localized, for: .normal)
        view.setTitleColor(Color.redBase, for: .normal)
        view.backgroundColor = Color.gray100
        view.tintColor = Color.redBase
        view.addTarget(self, action: #selector(handleOpenMenu), for: .touchUpInside)
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
    func handleTraceRoute() {
        onTraceRouteTapped?()
    }
    
    @objc
    func handleOpenMenu() {
        onMenuTapped?()
    }
}

extension PlaceDetailButtonsView {
    public func setup(place: Place) {
        placeNameLabel.text = place.restaurantName
        placeAddressLabel.text = place.address
        placeInfoLabel.text = place.type
    }
}

extension PlaceDetailButtonsView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(placeNameLabel)
        addSubview(placeAddressLabel)
        addSubview(placeInfoLabel)
        addSubview(traceRouteButton)
        addSubview(menuButton)
    }
    
    func setViewConstraints() {
        placeNameLabel.snp.makeConstraints { make in
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
        
        traceRouteButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(PlaceDetailButtonsConstants.padding)
            make.trailing.equalTo(self.snp.centerX).offset(-Metrics.tiny)
            make.bottom.equalToSuperview().inset(PlaceDetailButtonsConstants.padding)
            make.height.equalTo(PlaceDetailButtonsConstants.buttonHeight)
        }
        
        menuButton.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.centerX).offset(Metrics.tiny)
            make.trailing.equalToSuperview().offset(-PlaceDetailButtonsConstants.padding)
            make.bottom.equalToSuperview().inset(PlaceDetailButtonsConstants.padding)
            make.height.equalTo(PlaceDetailButtonsConstants.buttonHeight)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.grayTransparent80p
        traceRouteButton.layer.masksToBounds = true
        traceRouteButton.layer.cornerRadius = PlaceDetailButtonsConstants.cornerRadius
        traceRouteButton.layer.borderWidth = PlaceDetailButtonsConstants.borderWidth
        traceRouteButton.layer.borderColor = Color.gray100.cgColor
        menuButton.layer.masksToBounds = true
        menuButton.layer.cornerRadius = PlaceDetailButtonsConstants.cornerRadius
        menuButton.layer.borderWidth = PlaceDetailButtonsConstants.borderWidth
        menuButton.layer.borderColor = Color.gray100.cgColor
    }
}
