//
//  MenuItemCell.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 30/12/25.
//

import UIKit
import SnapKit
import Kingfisher

struct MenuItemCellConstants {
    static let iconWidth = 84.0
    static let iconHeight = 84.0
    static let leadingPadding = 14.0
    static let trailingPadding = 20.0
    static let topNameLabel = 20.0
    static let priceLabelTopPadding = 12.0
    static let buttonSize = 24.0
    static let countViewSize = 32.0
    static let separatorHeight = 1.0
}

class MenuItemCell: UITableViewCell {
    
    static let reuseIdentifier: String = "MenuItemCell"
    public var handleAddItem: (() -> Void)?
    public var handleRemoveItem: (() -> Void)?

    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.masksToBounds = true
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
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var itemPriceLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray500
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray200
        return view
    }()
    
    private lazy var countItensView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.gray200.cgColor
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    private lazy var countItensLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.labelXs
        view.textColor = Color.gray400
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var addItem: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.setImage(UIImage(named: "add"), for: .normal)
        view.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        view.titleLabel?.font = Typography.labelXs
        return view
    }()
    
    private lazy var removeItemButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.setImage(UIImage(named: "remove"), for: .normal)
        view.addTarget(self, action: #selector(handleRemove), for: .touchUpInside)
        view.titleLabel?.font = Typography.labelXs
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
            placeImageView.kf.setImage(with: url,
                                       placeholder: UIImage(systemName: "photo"),
                                       options: [.transition(.fade(0.3))]
            )
        }
    }
    
    @objc
    private func handleAdd() {
        handleAddItem?()
    }
    
    @objc
    private func handleRemove() {
        handleRemoveItem?()
    }
}

extension MenuItemCell {
    func setup(_ menuItem: MenuItem?) {
        if let menuItem = menuItem {
            countItensLabel.text = "\(menuItem.selectedCount)"
            itemNameLabel.text = menuItem.name
            itemPriceLabel.text = "\(menuItem.price)"
            loadImage(with: menuItem.imageUrl)
        }
    }
}

extension MenuItemCell: ViewCodeProtocol {
    func setViewHierarchy() {
        contentView.addSubview(placeImageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemPriceLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(removeItemButton)
        contentView.addSubview(countItensView)
        contentView.addSubview(addItem)
        countItensView.addSubview(countItensLabel)
    }
    
    func setViewConstraints() {
        placeImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(MenuItemCellConstants.iconWidth)
            make.height.equalTo(MenuItemCellConstants.iconHeight)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(MenuItemCellConstants.topNameLabel)
            make.leading.equalTo(placeImageView.snp.trailing).offset(MenuItemCellConstants.leadingPadding)
            make.trailing.equalToSuperview().offset(-MenuItemCellConstants.trailingPadding)
        }
        
        itemPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(MenuItemCellConstants.topNameLabel)
            make.leading.equalTo(placeImageView.snp.trailing).offset(MenuItemCellConstants.leadingPadding)
            make.trailing.equalTo(addItem.snp.leading).offset(-MenuItemCellConstants.trailingPadding)
        }
        
        removeItemButton.snp.makeConstraints { make in
            make.centerY.equalTo(itemPriceLabel)
            make.size.equalTo(MenuItemCellConstants.buttonSize)
            make.trailing.equalToSuperview()
        }
        
        countItensView.snp.makeConstraints { make in
            make.centerY.equalTo(itemPriceLabel)
            make.size.equalTo(MenuItemCellConstants.countViewSize)
            make.trailing.equalTo(removeItemButton.snp.leading).offset(-Metrics.nano)
        }
        
        countItensLabel.snp.makeConstraints { make in
            make.center.equalTo(countItensView)
        }
        
        addItem.snp.makeConstraints { make in
            make.centerY.equalTo(itemPriceLabel)
            make.size.equalTo(MenuItemCellConstants.buttonSize)
            make.trailing.equalTo(countItensView.snp.leading).offset(-Metrics.nano)
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
