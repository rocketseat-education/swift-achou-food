//
//  MenuSectionsView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 29/12/25.
//

import UIKit
import SnapKit

final class MenuSectionsView: UIView {

    private var items: [MenuCategory] = []
    private var selectedIndex: Int? // ✅ controla seleção (pode ser nil)

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

        // Fonte
        button.titleLabel?.font = Typography.label2Xs
        button.titleLabel?.textColor = Color.gray400

        // "pill"
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.clipsToBounds = true

        // padding interno
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

        // Altura fixa para ficar consistente
        button.snp.makeConstraints { make in
            make.height.equalTo(26)
        }

        // Estado inicial (desselecionado)
        applyDeselectedStyle(to: button)

        // Ação
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
            return
        }
        if let previousIndex = selectedIndex,
           let previousButton = stackView.arrangedSubviews[safe: previousIndex] as? UIButton {
            applyDeselectedStyle(to: previousButton)
        }

        applySelectedStyle(to: sender)
        selectedIndex = index

        print("Selecionado:", index)
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
            make.height.equalTo(26) // altura do componente (ajuste se quiser)
        }

        // Conteúdo do scroll
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(scrollView) // ✅ scroll horizontal: altura travada
        }

        // Stack com padding lateral
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16) // ✅ define o contentSize horizontal
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


