//
//  OrderView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 25/01/26.
//

//
//  PlaceMenuView.swift
//  AchouFood
//
//  Created by Arthur Rios on 07/01/26.
//

import UIKit
import SnapKit
import Kingfisher

struct OrderConstants {
}

class OrderView: UIView {
    
    var emptyOrderButtonTapped: (() -> Void)?
    
    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.label2Xs
        view.textColor = Color.gray500
        view.text = "PEDIDO"
        return view
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleSm
        view.textColor = Color.gray500
        view.text = "Acompanhe seu pedido"
        return view
    }()
    
    private lazy var emptyOrderView = EmptyOrderView()
    
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
    
    private func loadImage(with urlString: String) {
        if let url = URL(string: urlString) {
            placeImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.3))]
            )
        }
    }
    
    private func bindActions() {
        emptyOrderView.emptyOrderButtonTapped = { [weak self] in
            self?.emptyOrderButtonTapped?()
        }
    }
}

extension OrderView {
    public func setup() {
        emptyOrderView.isHidden = !OrderManager.shared.isEmpty()
    }
}

extension OrderView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(placeImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(contentView)
        contentView.addSubview(emptyOrderView)
    }
    
    func setViewConstraints() {
        
        placeImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(PlaceMenuConstants.placeImagePadding)
            make.size.equalTo(PlaceMenuConstants.placeImageSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(Metrics.small)
            make.top.equalTo(placeImageView)
            make.trailing.equalToSuperview().inset(Metrics.medium)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(Metrics.small)
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(Metrics.medium)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(placeImageView.snp.bottom).offset(Metrics.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyOrderView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.height.equalTo(220.0)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray200
        
        placeImageView.layer.cornerRadius = PlaceMenuConstants.placeImageRadius
        placeImageView.layer.borderWidth = PlaceMenuConstants.placeImageBorderWidth
        placeImageView.layer.borderColor = UIColor.white.cgColor
        
        contentView.layer.cornerRadius = Metrics.medium
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.clipsToBounds = true
    }
}
