//
//  MenuItemCell.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 18/01/26.
//

import UIKit
import SnapKit
import Kingfisher

struct MenuItemCellConstants {
    static let imageWith = 84.0
    static let imageHeight = 80.0
    static let topTitlePadding = 24.0
    static let leadingPricePadding = 14.0
    static let separatorHeight = 1.0
    static let topPricePadding = 20.0
    static let buttonSize = 20.0
    static let countViewSize = 32.0
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
        return view
    }()
    
    private lazy var addItem: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.setImage(UIImage(named: "add"), for: .normal)
        view.titleLabel?.font = Typography.labelXs
        view.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return view
    }()
    
    private lazy var removeItem: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.setImage(UIImage(named: "remove"), for: .normal)
        view.titleLabel?.font = Typography.labelXs
        view.addTarget(self, action: #selector(handleRemove), for: .touchUpInside)
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
    
    @objc
    private func handleAdd() {
        
    }
    
    @objc
    private func handleRemove() {
        
    }
}

extension MenuItemCell {
    func setup(_ menuItem: MenuItem?) {
        guard let menuItem = menuItem else { return }
        countItensLabel.text = "\(menuItem.selectedCount)"
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
        contentView.addSubview(addItem)
        contentView.addSubview(countItensView)
        contentView.addSubview(removeItem)
        countItensView.addSubview(countItensLabel)
    }
    
    func setViewConstraints() {
        placeImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(MenuItemCellConstants.imageWith)
            make.height.equalTo(MenuItemCellConstants.imageHeight)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(MenuItemCellConstants.topTitlePadding)
            make.leading.equalTo(placeImageView.snp.trailing).offset(MenuItemCellConstants.leadingPricePadding)
            make.trailing.equalToSuperview()
        }
        
        itemPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(MenuItemCellConstants.topPricePadding)
            make.leading.equalTo(placeImageView.snp.trailing).offset(MenuItemCellConstants.leadingPricePadding)
            make.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(MenuItemCellConstants.separatorHeight)
        }
        
        addItem.snp.makeConstraints { make in
            make.centerY.equalTo(itemPriceLabel)
            make.size.equalTo(MenuItemCellConstants.buttonSize)
            make.trailing.equalToSuperview()
        }
        
        countItensView.snp.makeConstraints { make in
            make.centerY.equalTo(itemPriceLabel)
            make.size.equalTo(MenuItemCellConstants.countViewSize)
            make.trailing.equalTo(addItem.snp.leading).offset(-Metrics.nano)
        }
        
        countItensLabel.snp.makeConstraints { make in
            make.center.equalTo(countItensView)
        }
        
        removeItem.snp.makeConstraints { make in
            make.centerY.equalTo(itemPriceLabel)
            make.size.equalTo(MenuItemCellConstants.buttonSize)
            make.trailing.equalTo(countItensView.snp.leading).offset(-Metrics.nano)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray100
        selectionStyle = .none
    }
}
