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
    
    private lazy var emptyOrderIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "receipt"))
        view.tintColor = Color.redBase
        return view
    }()
    
    private lazy var emptyOrderLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray500
        view.text = "Você ainda não adicionou items"
        return view
    }()
    
    private lazy var emptyOrderButton: UIButton = {
        let view  = UIButton()
        view.backgroundColor = Color.grayTransparent80p
        view.setTitle("EXPLORAR", for: .normal)
        view.setTitleColor(Color.gray500, for: .normal)
        view.titleLabel?.font = Typography.labelXs
        view.addTarget(self, action: #selector(handleEmptyOrder), for: .touchUpInside)
        view.setImage(UIImage(named: "menu"), for: .normal)
        return view
    }()
    
    private lazy var emptyOrderStack: UIStackView = {
        let view  = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.alignment = .center
        view.isHidden = false
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
    
    @objc
    private func handleEmptyOrder() {
        
    }
}

extension OrderView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(placeImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(contentView)
        contentView.addSubview(emptyOrderStack)
        emptyOrderStack.addArrangedSubview(emptyOrderIcon)
        emptyOrderStack.addArrangedSubview(emptyOrderLabel)
        emptyOrderStack.addArrangedSubview(emptyOrderButton)
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
        
        emptyOrderStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(68.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        emptyOrderButton.snp.makeConstraints { make in
            make.width.equalTo(130.0)
        }
        
        emptyOrderIcon.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(36)
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
        
        emptyOrderButton.clipsToBounds = true
        emptyOrderButton.layer.cornerRadius = OrderDetaisConstants.buttonRadius
        emptyOrderButton.layer.borderWidth = OrderDetaisConstants.buttonBorder
        emptyOrderButton.layer.borderColor = Color.gray100.cgColor
    }
}
