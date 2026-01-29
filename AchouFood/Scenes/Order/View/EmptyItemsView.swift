//
//  EmptyItemsView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 28/01/26.
//

import UIKit
import SnapKit
import Kingfisher

struct EmpryOrderConstants {
}

class EmptyOrderView: UIView {
    
    var emptyOrderButtonTapped: (() -> Void)?
    
    private lazy var emptyOrderIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "receipt"))
        view.tintColor = Color.redBase
        return view
    }()
    
    private lazy var emptyOrderLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray500
        view.text = "Você ainda não adicionou items"
        return view
    }()
    
    private lazy var emptyOrderButton: UIButton = {
        let view  = UIButton()
        view.backgroundColor = Color.grayTransparent80p
        view.setTitle("EXPLORAR", for: .normal)
        view.setTitleColor(Color.gray500, for: .normal)
        view.titleLabel?.font = Typography.labelXs
        view.addTarget(self, action: #selector(handleEmptyOrder), for: .touchUpInside)
        view.setImage(UIImage(named: "menu"), for: .normal)
        return view
    }()
    
    private lazy var emptyOrderStack: UIStackView = {
        let view  = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.alignment = .center
        return view
    }()
    
    public init() {
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
        addSubview(emptyOrderStack)
        emptyOrderStack.addArrangedSubview(emptyOrderIcon)
        emptyOrderStack.addArrangedSubview(emptyOrderLabel)
        emptyOrderStack.addArrangedSubview(emptyOrderButton)
    }
    
    func setViewConstraints() {
        
        emptyOrderStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(48.0)
            make.leading.trailing.equalToSuperview()
        }
        
        emptyOrderButton.snp.makeConstraints { make in
            make.width.equalTo(130.0)
        }
        
        emptyOrderIcon.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
        emptyOrderButton.clipsToBounds = true
        emptyOrderButton.layer.cornerRadius = OrderDetaisConstants.buttonRadius
        emptyOrderButton.layer.borderWidth = OrderDetaisConstants.buttonBorder
        emptyOrderButton.layer.borderColor = Color.gray100.cgColor
    }
}
