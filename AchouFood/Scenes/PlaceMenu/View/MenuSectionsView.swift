//
//  MenuSectionsView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 29/12/25.
//

import UIKit
import SnapKit

struct MenuSectionsConstants {
    static let sectionHeight = 26.0
    static let hoizontalPadding = 16.0
}

final class MenuSectionsView: UIView {

    private var items: [MenuCategory] = []
    private var selectedIndex: Int? = nil
    var itemSelected: ((Int?) -> Void)? = nil

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        sv.backgroundColor = .clear
        return sv
    }()

    private lazy var contentView: UIView = {
        UIView()
    }()

    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 8 // ✅ distância entre os botões
        return sv
    }()

    init() {
        super.init(frame: .zero)
        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public API
extension MenuSectionsView {

    func setup(menuItens: [MenuCategory]) {
        self.items = menuItens
        self.selectedIndex = nil // ✅ inicia sem seleção

        // Limpa botões anteriores (reuso seguro)
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        // Cria botões
        for (index, item) in menuItens.enumerated() {
            let button = makeButton(title: item.category, index: index)
            stackView.addArrangedSubview(button)
        }
    }
}

// MARK: - Actions / Styling
private extension MenuSectionsView {

    func makeButton(title: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)

        button.titleLabel?.font = Typography.label2Xs
        button.titleLabel?.textColor = Color.gray400

        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.clipsToBounds = true

        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

        button.snp.makeConstraints { make in
            make.height.equalTo(MenuSectionsConstants.sectionHeight)
        }

        applyDeselectedStyle(to: button)

        button.tag = index
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)

        return button
    }

    func applySelectedStyle(to button: UIButton) {
        button.backgroundColor = Color.redDark
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = Color.gray200.cgColor
    }

    func applyDeselectedStyle(to button: UIButton) {
        button.backgroundColor = .clear
        button.setTitleColor(.lightGray, for: .normal)
        button.layer.borderColor = Color.gray200.cgColor
    }

    @objc func didTapButton(_ sender: UIButton) {
        let index = sender.tag
        guard items.indices.contains(index) else { return }

        if selectedIndex == index {
            applyDeselectedStyle(to: sender)
            selectedIndex = nil
            itemSelected?(selectedIndex)
            return
        }
        
        if let previousIndex = selectedIndex,
           let previousButton = stackView.arrangedSubviews[safe: previousIndex] as? UIButton {
            applyDeselectedStyle(to: previousButton)
        }

        applySelectedStyle(to: sender)
        selectedIndex = index
        itemSelected?(selectedIndex)
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
            make.edges.equalToSuperview()
            make.height.equalTo(scrollView)
        }

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(MenuSectionsConstants.hoizontalPadding)
        }
    }

    func setViewConfigs() {
        backgroundColor = .clear
    }
}

// MARK: - Safe subscript helper
private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}


