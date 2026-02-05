//
//  OrderDetailsView.swift
//  AchouFood
//
//  Created by Arthur Rios on 23/01/26.
//

import UIKit
import SnapKit

struct OrderDetailsConstants {
    static let orderButtonTitle = "placeMenu.order.buttonTitle".localized
    static let buttonPadding = 20.0
    static let buttonWidth = 140.0
    static let buttonRadius = 20.0
    static let buttonBorder = 1.0
}

class OrderDetailsView: UIView {
    
    var onOrderButtonTapped: (() -> Void)?
    
    private lazy var itemsLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.label2Xs
        view.textColor = Color.gray600
        return view
    }()
    
    private lazy var totalLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleMd
        view.textColor = Color.gray600
        return view
    }()
    
    private lazy var orderButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = Color.grayTransparent80p
        view.setTitle(OrderDetailsConstants.orderButtonTitle, for: .normal)
        view.setTitleColor(Color.gray500, for: .normal)
        view.titleLabel?.font = Typography.labelXs
        view.addTarget(self, action: #selector(handleOrder), for: .touchUpInside)
        view.setImage(UIImage(named: "order"), for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleOrder() {
        onOrderButtonTapped?()
    }
}

extension OrderDetailsView {
    func setup(items: String, total: String) {
        itemsLabel.text = items
        totalLabel.text = total
    }
}

extension OrderDetailsView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(orderButton)
        addSubview(itemsLabel)
        addSubview(totalLabel)
    }
    
    func setViewConstraints() {
        orderButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(OrderDetailsConstants.buttonPadding)
            make.width.equalTo(OrderDetailsConstants.buttonWidth)
        }
        
        itemsLabel.snp.makeConstraints { make in
            make.top.equalTo(orderButton)
            make.leading.equalToSuperview().inset(Metrics.medium)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(itemsLabel.snp.bottom)
            make.leading.equalTo(itemsLabel)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.grayTransparent80p
        orderButton.layer.masksToBounds = true
        orderButton.layer.cornerRadius = OrderDetailsConstants.buttonRadius
        orderButton.layer.borderWidth = OrderDetailsConstants.buttonBorder
        orderButton.layer.borderColor = Color.gray100.cgColor
    }
}
