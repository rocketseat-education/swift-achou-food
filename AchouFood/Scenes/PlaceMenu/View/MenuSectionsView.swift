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
}

extension MenuSectionsView {
    func setup(menuItems: [MenuCategory]) {
        if menuItems.isEmpty { return }
        self.items = menuItems
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
