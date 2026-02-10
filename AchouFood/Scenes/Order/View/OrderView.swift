//
//  OrderView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 28/01/26.
//

import UIKit
import SnapKit
import Kingfisher

struct OrderConstants {
    static let orderTitle = "placeMenu.order.title".localized
    static let orderSubTitle = "placeMenu.order.subtitle".localized
    static let placeViewSize = 36.0
    static let placeImageViewSize = 22.0
    static let placeViewRadius = 8.0
    static let placeViewBorderWith = 1.0
    static let emptyOrderHeight = 220.0
}

class OrderView: UIView {
    
    var emptyOrderButtonTapped: (() -> Void)?
    var place: Place?
    
    private lazy var placeView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray300
        return view
    }()
    
    private lazy var placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "redReceipt")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.label2Xs
        label.textColor = Color.gray500
        label.text = OrderConstants.orderTitle
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.titleSm
        label.textColor = Color.gray500
        label.text = OrderConstants.orderSubTitle
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray100
        return view
    }()
    
    private lazy var emptyOrderView = EmptyOrderView()
    private lazy var openOrderView = OpenOrderView()
    private lazy var closedOrderView = ClosedOrderView()
    
    init() {
        super.init(frame: .zero)
        buildLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindActions() {
        emptyOrderView.emptyOrderButtonTapped = { [weak self] in
            self?.emptyOrderButtonTapped?()
        }
        
        openOrderView.orderButtonTapped = { [weak self] in
            guard let self = self else { return }
            if let place = place {
                self.openOrderView.isHidden = true
                self.closedOrderView.isHidden = false
                self.closedOrderView.setup(place: place)
            }
        }
    }
}

extension OrderView {
    public func setup(place: Place?) {
        guard let place = place else { return }
        self.place = place
        
        if OrderManager.shared.getItems().isEmpty {
            emptyOrderView.isHidden = false
            openOrderView.isHidden = true
            closedOrderView.isHidden = true
        } else {
            emptyOrderView.isHidden = true
            openOrderView.isHidden = false
            closedOrderView.isHidden = true
            openOrderView.setup(place: place)
        }
    }
}

extension OrderView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(placeView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(contentView)
        placeView.addSubview(placeImageView)
        contentView.addSubview(emptyOrderView)
        contentView.addSubview(closedOrderView)
        contentView.addSubview(openOrderView)
    }
    
    func setViewConstraints() {
        placeView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Metrics.medium)
            make.leading.equalToSuperview().offset(Metrics.medium)
            make.size.equalTo(OrderConstants.placeViewSize)
        }
        
        placeImageView.snp.makeConstraints { make in
            make.size.equalTo(OrderConstants.placeImageViewSize)
            make.center.equalTo(placeView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(placeImageView)
            make.leading.equalTo(placeView.snp.trailing).offset(Metrics.small)
            make.trailing.equalToSuperview().inset(Metrics.medium)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(placeView.snp.trailing).offset(Metrics.small)
            make.trailing.equalToSuperview().inset(Metrics.medium)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(placeView.snp.bottom).offset(Metrics.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyOrderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.medium)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(OrderConstants.emptyOrderHeight)
        }
        
        openOrderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        closedOrderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray200
        
        placeView.clipsToBounds = true
        placeView.layer.cornerRadius = OrderConstants.placeViewRadius
        placeView.layer.borderWidth = OrderConstants.placeViewBorderWith
        placeView.layer.borderColor = UIColor.white.cgColor
        
        contentView.layer.cornerRadius = Metrics.medium
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.clipsToBounds = true
        
        emptyOrderView.isHidden = false
        closedOrderView.isHidden = true
        openOrderView.isHidden = true
    }
    
}
