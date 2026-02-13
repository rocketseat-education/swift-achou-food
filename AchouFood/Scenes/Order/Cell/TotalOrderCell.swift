//
//  TotalOrderCell.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 08/02/26.
//

import UIKit
import SnapKit
import Kingfisher

class TotalOrderCell: UITableViewCell {
    
    static let reuseIdentifier: String = "totalOrderCell"
    
    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.gray200.cgColor
        return view
    }()
    
    private lazy var placeNameLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleMd
        view.textColor = .black
        return view
    }()
    
    private lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodyXs
        view.textColor = Color.gray400
        return view
    }()
    
    private lazy var totalLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleSm
        view.textColor = Color.gray500
        return view
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
}

extension TotalOrderCell {
    func setup(place: Place, qtdItens: String, total: String) {
        placeNameLabel.text = place.restaurantName
        addressLabel.text = qtdItens
        totalLabel.text = total
        placeImageView.loadImage(from: place.imageUrl)
    }
}

extension TotalOrderCell: ViewCodeProtocol {
    func setViewHierarchy() {
        contentView.addSubview(placeImageView)
        contentView.addSubview(placeNameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(totalLabel)
        contentView.addSubview(separatorView)
    }
    
    func setViewConstraints() {
        placeImageView.snp.makeConstraints { (make) in
            make.centerY.leading.equalToSuperview()
            make.size.equalTo(48.0)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(placeImageView.snp.top).offset(Metrics.nano)
            make.leading.equalTo(placeImageView.snp.trailing).offset(14.0)
            make.trailing.equalToSuperview().offset(-Metrics.medium)
        }
        
        addressLabel.snp.makeConstraints { make in
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
