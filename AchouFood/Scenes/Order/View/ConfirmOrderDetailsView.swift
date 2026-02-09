//
//  ConfirmOrderDetailsView.swift
//  AchouFood
//
//  Created by Arthur Rios on 09/02/26.
//

import UIKit
import SnapKit

struct ConfirmOrderDetailsConstants {
    static let orderButtonTitle = "placeMenu.order.buttonTitle".localized
    static let buttonPadding = 20.0
    static let buttonWidth = 161.0
    static let buttonRadius = 20.0
    static let buttonBorder = 1.0
}

class ConfirmOrderDetailsView: UIView {
    
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
        view.setTitle("CONFIRMAR PEDIDO", for: .normal)
        view.setTitleColor(Color.redBase, for: .normal)
        view.titleLabel?.font = Typography.labelXs
        view.addTarget(self, action: #selector(handleOrder), for: .touchUpInside)
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

extension ConfirmOrderDetailsView {
    func setup(items: String, total: String) {
        itemsLabel.text = items
        totalLabel.text = total
    }
}

extension ConfirmOrderDetailsView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(orderButton)
        addSubview(itemsLabel)
        addSubview(totalLabel)
    }
    
    func setViewConstraints() {
        orderButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(ConfirmOrderDetailsConstants.buttonPadding)
            make.width.equalTo(ConfirmOrderDetailsConstants.buttonWidth)
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
        orderButton.layer.cornerRadius = ConfirmOrderDetailsConstants.buttonRadius
        orderButton.layer.borderWidth = ConfirmOrderDetailsConstants.buttonBorder
        orderButton.layer.borderColor = Color.gray100.cgColor
    }
}
