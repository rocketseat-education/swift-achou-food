//
//  OrderSuccessBanner.swift
//  AchouFood
//
//  Created by Arthur Rios on 09/02/26.
//

import UIKit
import SnapKit

final class OrderSuccessBanner: UIView {
    
    private lazy var orderIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "order")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.successBase
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Pedido feito com sucesso!"
        label.font = Typography.titleSm
        label.textColor = Color.gray500
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodyXs
        label.textColor = Color.gray400
        label.numberOfLines = 3
        return label
    }()
    
    public init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OrderSuccessBanner {
    func setup(placeName: String) {
        descriptionLabel.text = "\(placeName) já está preparando seu pedido. Agora é só aguardar chegar em sua casa!"
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
            make.top.leading.equalToSuperview().inset(Metrics.regular)
            make.size.equalTo(Metrics.medium)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(orderIcon).offset(Metrics.nano)
            make.leading.equalTo(orderIcon.snp.trailing).offset(Metrics.small)
            make.trailing.equalToSuperview().offset(-Metrics.regular)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metrics.nano)
            make.leading.equalTo(orderIcon.snp.trailing).offset(Metrics.small)
            make.trailing.equalToSuperview().offset(-Metrics.regular)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.successTransparent
    }
}
