//
//  ConfirmOrderDetailsView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 07/02/26.
//


import UIKit
import SnapKit


struct ConfirmOrderDetailsConstants {
    static let orderTitleButton = "placeMenu.order.buttonTitle".localized
    static let buttonPadding = 20.0
    static let buttonWidth = 140.0
    static let buttonRadius = 20.0
    static let buttonBorder = 1.0
}

class ConfirmOrderDetailsView: UIView {
    
    var orderButtonTapped: (() -> Void)?
    
    private lazy var itensLabel: UILabel = {
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
        let view  = UIButton()
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
        orderButtonTapped?()
    }
}

extension ConfirmOrderDetailsView {
    func setup(itens: String, total: String) {
        itensLabel.text = itens
        totalLabel.text = total
    }
}

extension ConfirmOrderDetailsView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(orderButton)
        addSubview(itensLabel)
        addSubview(totalLabel)
    }
    
    func setViewConstraints() {
        orderButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(OrderDetaisConstants.buttonPadding)
            make.width.equalTo(OrderDetaisConstants.buttonWidth)
        }
        
        itensLabel.snp.makeConstraints { make in
            make.top.equalTo(orderButton)
            make.leading.equalToSuperview().inset(Metrics.medium)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(itensLabel.snp.bottom)
            make.leading.equalTo(itensLabel)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.grayTransparent80p
        orderButton.clipsToBounds = true
        orderButton.layer.cornerRadius = OrderDetaisConstants.buttonRadius
        orderButton.layer.borderWidth = OrderDetaisConstants.buttonBorder
        orderButton.layer.borderColor = Color.gray100.cgColor
    }
    
}
