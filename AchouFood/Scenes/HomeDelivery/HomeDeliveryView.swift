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
}

class HomeDeliveryView: UIView {
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray100
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
        addSubview(backgroundView)
    }
    
    func setViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(Constants.headerHeight)
            make.top.leading.trailing.equalToSuperview().inset(Constants.margin)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Metrics.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.redDark
        backgroundView.layer.cornerRadius = Constants.cornerRadius
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
