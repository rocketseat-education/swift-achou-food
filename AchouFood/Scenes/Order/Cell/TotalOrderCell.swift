//
//  TotalOrderCell.swift
//  AchouFood
//
//  Created by Arthur Rios on 10/02/26.
//

import UIKit
import SnapKit
import Kingfisher

final class TotalOrderCell: UITableViewCell {
    
    static let reuseIdentifier: String = "TotalOrderCell"
    
    private lazy var placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = Color.gray200.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    private lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.titleMd
        label.textColor = Color.gray600
        return label
    }()
    
    private lazy var itemsQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodyXs
        label.textColor = Color.gray400
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.titleSm
        label.textColor = Color.gray500
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray200
        return view
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = nil) {
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

extension TotalOrderCell {
    func setup(with place: Place, itemsQtt: String, total: String) {
        placeNameLabel.text = place.restaurantName
        itemsQuantityLabel.text = itemsQtt
        totalLabel.text = total
        loadImage(with: place.imageUrl)
    }
}

extension TotalOrderCell: ViewCodeProtocol {
    func setViewHierarchy() {
        contentView.addSubview(placeImageView)
        contentView.addSubview(placeNameLabel)
        contentView.addSubview(itemsQuantityLabel)
        contentView.addSubview(totalLabel)
        contentView.addSubview(separatorView)
    }
    
    func setViewConstraints() {
        placeImageView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.size.equalTo(48.0)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(placeImageView.snp.top).offset(Metrics.nano)
            make.leading.equalTo(placeImageView.snp.trailing).offset(14.0)
            make.trailing.equalToSuperview().offset(-Metrics.medium)
        }
        
        itemsQuantityLabel.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(Metrics.nano)
            make.leading.equalTo(placeImageView.snp.trailing).offset(14.0)
            make.trailing.equalToSuperview().offset(-Metrics.medium)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(placeImageView)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(placeImageView.snp.bottom).offset(Metrics.small)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}
