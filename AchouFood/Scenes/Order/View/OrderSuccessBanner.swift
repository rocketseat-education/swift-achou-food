//
//  OrderSuccessBanner.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 07/02/26.
//

import UIKit
import SnapKit

class OrderSuccessBanner: UIView {
    
    private lazy var orderIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "orderSuccess")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Pedido feito com sucesso"
        view.font = Typography.titleSm
        view.textColor = Color.gray500
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodyXs
        view.textColor = Color.gray400
        view.numberOfLines = 3
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init (coder:) has not been implemented")
    }
}

extension OrderSuccessBanner {
    func setup(placeName: String) {
        descriptionLabel.text = "\(placeName) já está preparando seu pedido. Agora é só aguardar chegar em sua casa"
    }
}

extension OrderSuccessBanner: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(orderIcon)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    func setViewConstraints() {
        orderIcon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Metrics.medium)
            make.size.equalTo(Metrics.medium)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(orderIcon).offset(Metrics.nano)
            make.leading.equalTo(orderIcon.snp.trailing).offset(Metrics.small)
            make.trailing.equalToSuperview().offset(-Metrics.medium)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metrics.nano)
            make.leading.equalTo(orderIcon.snp.trailing).offset(Metrics.small)
            make.trailing.equalToSuperview().offset(-Metrics.medium)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.successTransparent
    }
}
