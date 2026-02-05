//
//  OpenOrderView.swift
//  AchouFood
//
//  Created by Arthur Rios on 05/02/26.
//

import UIKit
import SnapKit

final class OpenOrderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OpenOrderView: ViewCodeProtocol {
    func setViewHierarchy() {
    }
    
    func setViewConstraints() {
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
    }
}
