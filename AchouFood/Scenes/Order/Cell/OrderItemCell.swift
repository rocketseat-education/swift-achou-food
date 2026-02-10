//
//  OrderItemCell.swift
//  AchouFood
//
//  Created by Arthur Rios on 10/02/26.
//

import UIKit
import SnapKit
import Kingfisher

final class OrderItemCell: UITableViewCell {
    
    static let reuseIdentifier: String = "OrderItemCell"
    
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = Color.gray200.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.titleSm
        label.textColor = Color.gray600
        return label
    }()
    
    private lazy var itemsQttLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodyXs
        label.textColor = Color.gray400
        return label
    }()
    
    private lazy var itemTotalLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodyXs
        label.textColor = Color.gray500
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = nil) {
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
    func setup(with item: MenuItem) {
        itemNameLabel.text = item.name
        itemsQttLabel.text = "\(item.selectedCount) " + (item.selectedCount > 1 ? "unidades" : "unidade")
        itemTotalLabel.text = "R$ \(item.price)"
        loadImage(with: item.imageUrl)
    }
}

extension OrderItemCell: ViewCodeProtocol {
    func setViewHierarchy() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemsQttLabel)
        contentView.addSubview(itemTotalLabel)
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
        
        itemsQttLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(Metrics.nano)
            make.leading.equalTo(itemImageView.snp.trailing).offset(14.0)
            make.trailing.equalToSuperview().offset(-Metrics.medium)
        }
        
        itemTotalLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(itemImageView)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}
