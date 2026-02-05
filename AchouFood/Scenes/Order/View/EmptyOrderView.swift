//
//  EmptyOrderView.swift
//  AchouFood
//
//  Created by Arthur Rios on 05/02/26.
//

import UIKit
import SnapKit

struct EmptyOrderConstants {
    static let noItems = "order.title.empty".localized
    static let explore = "order.title.explore".localized
    static let stackTop = 48.0
    static let emptyOrderButtonWidth = 130.0
    static let orderIconSize = 36.0
    static let buttonRadius = 22.0
    static let buttonBorderWidth = 1.0
}

final class EmptyOrderView: UIView {
    
    var emptyOrderButtonTapped: (() -> Void)?
    
    private lazy var emptyOrderIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "order")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.redBase
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyOrderLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodySm
        label.textColor = Color.gray500
        label.text = EmptyOrderConstants.noItems
        return label
    }()
    
    private lazy var emptyOrderButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString(EmptyOrderConstants.explore)
        titleAttr.font = Typography.labelXs
        config.attributedTitle = titleAttr
        
        config.image = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
        config.imagePadding = 8
        config.baseForegroundColor = Color.gray500
        config.background.backgroundColor = Color.grayTransparent80p
        
        config.background.cornerRadius = EmptyOrderConstants.buttonRadius
        config.cornerStyle = .capsule
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(handleEmptyOrder), for: .touchUpInside)
        return button
    }()
    
    private lazy var emptyOrderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func handleEmptyOrder() {
        emptyOrderButtonTapped?()
    }
}

extension EmptyOrderView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(emptyOrderStackView)
        emptyOrderStackView.addArrangedSubview(emptyOrderIcon)
        emptyOrderStackView.addArrangedSubview(emptyOrderLabel)
        emptyOrderStackView.addArrangedSubview(emptyOrderButton)
    }
    
    func setViewConstraints() {
        emptyOrderStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(EmptyOrderConstants.stackTop)
            make.leading.trailing.equalToSuperview()
        }
        
        emptyOrderButton.snp.makeConstraints { make in
            make.width.equalTo(EmptyOrderConstants.emptyOrderButtonWidth)
            make.height.equalTo(44.0)
        }
        
        emptyOrderIcon.snp.makeConstraints { make in
            make.size.equalTo(EmptyOrderConstants.orderIconSize)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
        
        emptyOrderButton.clipsToBounds = false
        emptyOrderButton.layer.masksToBounds = false
        emptyOrderButton.layer.shadowColor = UIColor.black.cgColor
        emptyOrderButton.layer.shadowOpacity = 0.08
        emptyOrderButton.layer.shadowOffset = CGSize(width: 2, height: 4)
        emptyOrderButton.layer.shadowRadius = 8.0

        emptyOrderButton.layer.borderWidth = EmptyOrderConstants.buttonBorderWidth
        emptyOrderButton.layer.borderColor = Color.gray100.cgColor
    }
}
