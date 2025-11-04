//
//  PlaceCell.swift
//  AchouFood
//
//  Created by Arthur Rios on 04/11/25.
//

import UIKit
import SnapKit
import Kingfisher

struct CellConstants {
    static let iconSize = 48.0
    static let topMarginPlaceName = 19.5
    static let topMarginAddress = 2.0
    static let leftMargin = 14.0
    static let cellMargin = 20.0
}

class PlaceCell: UITableViewCell {
    
    static let reuseIdentifier: String = "PlaceCell"

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
    
    private lazy var placeNameLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleMd
        view.textColor = .black
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodyXs
        view.textColor = Color.gray400
        view.numberOfLines = 1
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
}

extension PlaceCell {
    func setup(_ place: Place) {
        placeNameLabel.text = place.restaurantName
        addressLabel.text = place.address
        loadImage(with: place.imageUrl)
    }
}

extension PlaceCell: ViewCodeProtocol {
    func setViewHierarchy() {
        contentView.addSubview(placeImageView)
        contentView.addSubview(placeNameLabel)
        contentView.addSubview(addressLabel)
    }
    
    func setViewConstraints() {
        placeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CellConstants.cellMargin)
            make.centerY.equalToSuperview()
            make.size.equalTo(CellConstants.iconSize)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CellConstants.topMarginPlaceName)
            make.leading.equalTo(placeImageView.snp.trailing).offset(CellConstants.leftMargin)
            make.trailing.equalToSuperview().offset(-CellConstants.cellMargin)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(CellConstants.topMarginAddress)
            make.leading.equalTo(placeImageView.snp.trailing).offset(CellConstants.leftMargin)
            make.trailing.equalToSuperview().offset(-CellConstants.cellMargin)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray100
        selectionStyle = .none
    }
}
