//
//  MenuItemCell.swift
//  AchouFood
//
//  Created by Arthur Rios on 22/01/26.
//

import UIKit
import SnapKit
import Kingfisher

struct MenuItemCellConstants {
    static let imageWidth = 84.0
    static let imageHeight = 80.0
    static let titleTopPadding = 32.0
    static let priceLeadingPadding = 14.0
    static let separatorHeight = 1.0
}

class MenuItemCell: UITableViewCell {
    
    static let identifier: String = "MenuItemCell"
    
    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.gray200.cgColor
        view.tintColor = Color.gray100
        return view
    }()
    
    private lazy var itemNameLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleSm
        view.textColor = Color.gray600
        return view
    }()
    
    private lazy var itemPriceLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray500
        return view
    }()
    
    private lazy var separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = Color.gray200
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
            placeImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.3))]
            )
        }
    }
}

extension MenuItemCell {
    func setup(_ menuItem: MenuItem?) {
        guard let menuItem = menuItem else { return }
        itemNameLabel.text = menuItem.name
        itemPriceLabel.text = "R$ \(menuItem.price)"
        loadImage(with: menuItem.imageUrl)
    }
}

extension MenuItemCell: ViewCodeProtocol {
    func setViewHierarchy() {
        contentView.addSubview(placeImageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemPriceLabel)
        contentView.addSubview(separatorView)
    }
    
    func setViewConstraints() {
        placeImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(MenuItemCellConstants.imageWidth)
            make.height.equalTo(MenuItemCellConstants.imageHeight)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(MenuItemCellConstants.titleTopPadding)
            make.leading.equalTo(placeImageView.snp.trailing).offset(MenuItemCellConstants.priceLeadingPadding)
            make.trailing.equalToSuperview()
        }
        
        itemPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(Metrics.nano)
            make.leading.equalTo(placeImageView.snp.trailing).offset(MenuItemCellConstants.priceLeadingPadding)
            make.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(MenuItemCellConstants.separatorHeight)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray100
        selectionStyle = .none
    }
}
