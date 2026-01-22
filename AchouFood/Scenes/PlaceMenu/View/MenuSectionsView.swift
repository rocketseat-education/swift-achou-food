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
    var scrollTableTo: ((Int) -> Void)?
    var currentSelectedButton: Int = 0
    var firstTime = true
    
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
            applyDeselectedStyle(to: button)
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
        button.layer.borderColor = Color.gray200.cgColor
    }
    
    private func applyDeselectedStyle(to button: UIButton) {
        button.backgroundColor = .clear
        button.setTitleColor(Color.gray400, for: .normal)
        button.layer.borderColor = Color.gray200.cgColor
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        let index = sender.tag
        guard items.indices.contains(index) else { return }
        setSelected(selectedIndex: index, needToScroll: true)
    }
}

extension MenuSectionsView {
    func setup(menuItems: [MenuCategory]) {
        if menuItems.isEmpty { return }
        self.items = menuItems
        createButtons()
        setSelected(selectedIndex: 0, needToScroll: false)
    }
    
    func setSelected(selectedIndex: Int, needToScroll: Bool) {
        guard items.indices.contains(selectedIndex) else { return }
        
        swapButtons(selectedIndex: selectedIndex)
        
        if needToScroll {
            scrollTableTo?(selectedIndex)
        }
    }
    
    func swapButtons(selectedIndex: Int) {
        
        if !firstTime && currentSelectedButton == selectedIndex {
            firstTime = false
            return
        }
        
        if let previousButton = stackView.arrangedSubviews[currentSelectedButton] as? UIButton {
            applyDeselectedStyle(to: previousButton)
        }
        
        if let currentButton = stackView.arrangedSubviews[selectedIndex] as? UIButton {
            applySelectedStyle(to: currentButton)
            let rect = currentButton.convert(currentButton.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect.insetBy(dx: -20, dy: 0), animated: true)
        }
        
        currentSelectedButton = selectedIndex
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
