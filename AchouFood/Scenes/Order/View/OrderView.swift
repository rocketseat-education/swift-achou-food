//
//  OrderView.swift
//  AchouFood
//
//  Created by Arthur Rios on 05/02/26.
//

import UIKit
import SnapKit
import Kingfisher

struct OrderConstants {
    static let orderTitle = "order.title".localized
    static let orderSubtitle = "order.subtitle".localized
    static let placeViewSize = 36.0
    static let placeImageViewSize = 22.0
    static let placeViewRadius = 8.0
    static let placeViewBorderWidth = 1.0
    static let emptyOrderHeight = 220.0
}

final class OrderView: UIView {
    
    var emptyOrderButtonTapped: (() -> Void)?
    private var place: Place?
    
    private lazy var placeView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray300
        return view
    }()
    
    private lazy var placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "order")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.redBase
        return imageView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2.0
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.label2Xs
        label.textColor = Color.gray500
        label.text = OrderConstants.orderTitle
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.titleSm
        label.textColor = Color.gray500
        label.text = OrderConstants.orderSubtitle
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
    
    override init(frame: CGRect) {
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
    }
}

extension OrderView {
    func setup(with place: Place?) {
        guard let place = place else { return }
        self.place = place
        openOrderView.setup(with: place)
        closedOrderView.setup(place: place)
    }
}

extension OrderView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(placeView)
        addSubview(textStackView)
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
        
        textStackView.snp.makeConstraints { make in
            make.centerY.equalTo(placeView)
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
        placeView.layer.borderWidth = OrderConstants.placeViewBorderWidth
        placeView.layer.borderColor = Color.gray100.cgColor
        
        contentView.layer.cornerRadius = Metrics.medium
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.clipsToBounds = true
        
        emptyOrderView.isHidden = true
        openOrderView.isHidden = true
        closedOrderView.isHidden = false
    }
}
