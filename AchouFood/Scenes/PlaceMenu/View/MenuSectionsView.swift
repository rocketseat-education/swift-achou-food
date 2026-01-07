//
//  MenuSectionsView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 29/12/25.
//

//
//  MenuSectionsView.swift
//  AchouFood
//

import UIKit
import SnapKit

struct MenuSectionsConstants {
    static let sectionHeight = 26.0
    static let horizontalPadding = 20.0
}

final class MenuSectionsView: UIView {

    private var items: [MenuCategory] = []
    private var selectedIndex: Int? = nil   // ✅ começa nil pra aplicar o primeiro highlight

    var scrollTableTo: ((Int) -> Void)?

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
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
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
            applyDeselectedStyle(to: button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func swapButtons(_ index: Int, _ animated: Bool) {
        
        if selectedIndex == index { return }
        
        if let previousIndex = selectedIndex,
           let previousButton = stackView.arrangedSubviews[previousIndex] as? UIButton {
            applyDeselectedStyle(to: previousButton)
        }

        if let currentButton = stackView.arrangedSubviews[index] as? UIButton {
            applySelectedStyle(to: currentButton)
            let rect = currentButton.convert(currentButton.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect.insetBy(dx: -20, dy: 0), animated: animated)
        }
        
        selectedIndex = index
    }
    
    private func applySelectedStyle(to button: UIButton) {
        button.backgroundColor = Color.redDark
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = Color.gray200.cgColor
    }

    private func applyDeselectedStyle(to button: UIButton) {
        button.backgroundColor = .clear
        button.setTitleColor(Color.gray400, for: .normal)
        button.layer.borderColor = Color.gray200.cgColor
    }
    
    private func makeButton(title: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Typography.label2Xs
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        button.tag = index
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.height.equalTo(MenuSectionsConstants.sectionHeight)
        }
        
        return button
    }

    @objc
    private func didTapButton(_ sender: UIButton) {
        let index = sender.tag
        guard items.indices.contains(index) else { return }
        setSelected(index: index, needToScroll: true, animated: true)
    }
}

extension MenuSectionsView {

    public func setup(menuItens: [MenuCategory]) {
        guard !menuItens.isEmpty else { return }
        self.items = menuItens
        createButtons()
        setSelected(index: 0, needToScroll: false, animated: false)
    }

    public func setSelected(index: Int, needToScroll: Bool = true, animated: Bool = true) {
        guard items.indices.contains(index) else { return }
        
        swapButtons(index, animated)

        if needToScroll {
            scrollTableTo?(index)
        }
    }
}

// MARK: - ViewCodeProtocol
extension MenuSectionsView: ViewCodeProtocol {

    func setViewHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
    }

    func setViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(MenuSectionsConstants.sectionHeight)
        }

        contentView.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(MenuSectionsConstants.horizontalPadding)
        }
    }

    func setViewConfigs() {
        backgroundColor = .clear
    }
}
