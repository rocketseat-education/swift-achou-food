//
//  MenuSectionsView.swift
//  AchouFood
//
//  Created by Arthur Rios on 09/01/26.
//

import UIKit
import SnapKit

struct MenuSectionsConstants {
    static let buttonsSpacing = 8.0
    static let scrollViewHeight = 26.0
    static let stackPadding = 20.0
}

final class MenuSectionsView: UIView {
    
    private var items: [MenuCategory] = []
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var contentView = UIView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = MenuSectionsConstants.buttonsSpacing
        return stackView
    }()
        
    init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButtons() {
        for (index, item) in items.enumerated() {
            let button = makeButton(title: item.category, index: index)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func makeButton(title: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Typography.label2Xs
        button.layer.cornerRadius = 12.0
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0)
        button.tag = index
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }
    
    private func applySelectedStyle(to button: UIButton) {
        button.backgroundColor = Color.redDark
        button.setTitleColor(Color.gray200, for: .normal)
    }
    
    private func applyDeselectedStyle(to button: UIButton) {
        button.backgroundColor = .clear
        button.setTitleColor(Color.gray400, for: .normal)
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        print(sender.tag)
    }
}

extension MenuSectionsView {
    func setup(menuItems: [MenuCategory]) {
        if menuItems.isEmpty { return }
        self.items = menuItems
        createButtons()
    }
}

extension MenuSectionsView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
    }
    
    func setViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(MenuSectionsConstants.scrollViewHeight)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(MenuSectionsConstants.stackPadding)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
    }
}
