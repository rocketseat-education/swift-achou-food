//
//  EmptyOrderView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 03/02/26.
//

import UIKit
import SnapKit

struct EmptyOrderConstants {
    static let noItems = "order.title.empty".localized
    static let explore = "order.title.explore".localized
    static let stackTop = 48.0
    static let emptyOrderButtonWidth = 130.0
    static let orderIconSize = 36.0
    static let buttonRadius = 20.0
    static let buttonBorderWith = 1.0
}

class EmptyOrderView: UIView {
    
    var emptyOrderButtonTapped: (() -> Void)?
    
    private lazy var emptyOrderIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "redReceipt"))
        view.contentMode = .scaleAspectFit
        return view
    }()
        
    private lazy var emptyOrderLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray500
        view.text = EmptyOrderConstants.noItems
        return view
    }()
    
    private lazy var emptyOrderButton: UIButton = {
        let view = UIButton()
        view.setTitle(EmptyOrderConstants.explore, for: .normal)
        view.setTitleColor(Color.gray500, for: .normal)
        view.titleLabel?.font = Typography.labelXs
        view.backgroundColor = Color.grayTransparent80p
        view.setImage(UIImage(named: "menu"), for: .normal)
        view.addTarget(self, action: #selector(handleEmptyOrder), for: .touchUpInside)
        return view
    }()
    
    private lazy var emptyOrderStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.alignment = .center
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleEmptyOrder() {
        emptyOrderButtonTapped?()
    }
}

extension EmptyOrderView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(emptyOrderStack)
        emptyOrderStack.addArrangedSubview(emptyOrderIcon)
        emptyOrderStack.addArrangedSubview(emptyOrderLabel)
        emptyOrderStack.addArrangedSubview(emptyOrderButton)
    }
    
    func setViewConstraints() {
        emptyOrderStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(EmptyOrderConstants.stackTop)
            make.leading.trailing.equalToSuperview()
        }
        emptyOrderButton.snp.makeConstraints { make in
            make.width.equalTo(EmptyOrderConstants.emptyOrderButtonWidth)
        }
        emptyOrderIcon.snp.makeConstraints { make in
            make.size.equalTo(EmptyOrderConstants.orderIconSize)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
        
        emptyOrderButton.clipsToBounds = true
        emptyOrderButton.layer.cornerRadius = EmptyOrderConstants.buttonRadius
        emptyOrderButton.layer.borderWidth = EmptyOrderConstants.buttonBorderWith
        emptyOrderButton.layer.borderColor = Color.gray100.cgColor
    }
}

