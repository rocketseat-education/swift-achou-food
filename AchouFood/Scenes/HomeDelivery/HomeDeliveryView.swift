//
//  HomeDeliveryView.swift
//  AchouFood
//
//  Created by Arthur Rios on 20/10/25.
//

import UIKit
import SnapKit

struct Constants {
    static let headerHeight = 36.0
    static let cornerRadius = 20.0
    static let margin = 20.0
    static let addressIcon = "AddressIcon"
    static let addressTitle = "home.header.addressTitle"
    static let userAddressKey = "userAddress"
    static let iconSize = 36.0
    static let marginSize = 12.0
}

class HomeDeliveryView: UIView {
    
    private lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var headerIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Constants.addressIcon)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var headerTitleAddressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.label2Xs
        view.textColor = Color.gray200
        view.text = Constants.addressTitle.localized
        return view
    }()
    
    private lazy var headerAddressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray200
        view.text = StorageManager.shared.get(forKey: Constants.userAddressKey)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = Color.gray100
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray100
        return view
    }()
    
    private lazy var listView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var mapView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeDeliveryView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(headerView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(listView)
        contentView.addSubview(mapView)
        headerView.addSubview(headerIcon)
        headerView.addSubview(headerTitleAddressLabel)
        headerView.addSubview(headerAddressLabel)
    }
    
    func setViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(Constants.headerHeight)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Metrics.medium)
            make.leading.trailing.equalToSuperview().inset(Constants.margin)
        }
        
        headerIcon.snp.makeConstraints { make in
            make.size.equalTo(Constants.iconSize)
            make.centerY.equalTo(headerView.snp.centerY)
            make.leading.equalToSuperview()
        }
        
        headerTitleAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(headerIcon.snp.top).offset(Metrics.little)
            make.leading.equalTo(headerIcon.snp.trailing).offset(Constants.marginSize)
            make.trailing.equalToSuperview()
        }
        
        headerAddressLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerIcon.snp.trailing).offset(Constants.marginSize)
            make.top.equalTo(headerTitleAddressLabel.snp.bottom).offset(Metrics.nano)
            make.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Metrics.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }
        
        listView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        mapView.snp.makeConstraints { make in
            make.leading.equalTo(listView.snp.trailing)
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.redDark
        scrollView.layer.cornerRadius = Constants.cornerRadius
        scrollView.layer.masksToBounds = true
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
