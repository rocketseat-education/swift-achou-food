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
    static let horizontalPadding = 16.0
}

final class MenuSectionsView: UIView {

    private var items: [MenuCategory] = []
    private var selectedIndex: Int? = nil   // ✅ começa nil pra aplicar o primeiro highlight

    var itemSelected: ((Int) -> Void)?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
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
}

// MARK: - Public API
extension MenuSectionsView {

    func setup(menuItens: [MenuCategory]) {
        self.items = menuItens

        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        guard !menuItens.isEmpty else { return }

        for (index, item) in menuItens.enumerated() {
            let button = makeButton(title: item.category, index: index)
            stackView.addArrangedSubview(button)
        }

        // ✅ estado inicial: primeiro selecionado (sem disparar callback)
        setSelected(index: 0, notify: false, animated: false)
    }

    func setSelected(index: Int, notify: Bool = true, animated: Bool = true) {
        guard items.indices.contains(index) else { return }
        guard selectedIndex != index else { return }

        if let previous = selectedIndex,
           let previousButton = stackView.arrangedSubviews[safe: previous] as? UIButton {
            applyDeselectedStyle(to: previousButton)
        }

        if let currentButton = stackView.arrangedSubviews[safe: index] as? UIButton {
            applySelectedStyle(to: currentButton)

            let rect = currentButton.convert(currentButton.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect.insetBy(dx: -16, dy: 0), animated: animated)
        }

        selectedIndex = index
        if notify { itemSelected?(index) }
    }
}

// MARK: - Actions / Styling
private extension MenuSectionsView {

    func makeButton(title: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)

        button.titleLabel?.font = Typography.label2Xs
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.clipsToBounds = true

        // altura é 26, então padding pequeno
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)

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
        button.setTitleColor(Color.gray400, for: .normal)
        button.layer.borderColor = Color.gray200.cgColor
    }

    @objc func didTapButton(_ sender: UIButton) {
        let index = sender.tag
        guard items.indices.contains(index) else { return }
        setSelected(index: index, notify: true, animated: true)
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
            make.height.equalTo(MenuSectionsConstants.sectionHeight) // ✅ garante visível
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(scrollView)
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

// MARK: - Safe subscript helper
private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}





