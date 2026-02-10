//
//  OrderItemCell.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 09/02/26.
//

import UIKit
import SnapKit
import Kingfisher

class OrderItemCell: UITableViewCell {
    
    static let reuseIdentifier: String = "orderItemCell"
    
    private lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.gray200.cgColor
        return view
    }()
    
    private lazy var itemNameLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleSm
        view.textColor = .black
        return view
    }()
    
    private lazy var qtdItemsLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodyXs
        view.textColor = Color.gray400
        return view
    }()
    
    private lazy var totalItemLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodyXs
        view.textColor = Color.gray500
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadImage(with urlString: String) {
        if let url = URL(string: urlString) {
            itemImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.3))]
            )
        }
    }
}

extension OrderItemCell {
    func setup(item: MenuItem) {
        itemNameLabel.text = item.name
        qtdItemsLabel.text = "\(item.selectedCount) " + (item.selectedCount > 1 ? "unidades" : "unidade")
        totalItemLabel.text = "R$ \(item.price)"
        loadImage(with: item.imageUrl)
    }
}


extension OrderItemCell: ViewCodeProtocol {
    func setViewHierarchy() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(qtdItemsLabel)
        contentView.addSubview(totalItemLabel)
    }
    
    func setViewConstraints() {
        itemImageView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.size.equalTo(40.0)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.top).offset(Metrics.nano)
            make.leading.equalTo(itemImageView.snp.trailing).offset(14.0)
            make.trailing.equalToSuperview().offset(-Metrics.medium)
        }
        
        qtdItemsLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(Metrics.nano)
            make.leading.equalTo(itemImageView.snp.trailing).offset(14.0)
            make.trailing.equalToSuperview().offset(-Metrics.medium)
        }
        
        totalItemLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(itemImageView)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray100
        selectionStyle = .none
    }
}
