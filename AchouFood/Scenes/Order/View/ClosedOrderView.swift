//
//  ClosedOrderView.swift
//  AchouFood
//
//  Created by Arthur Rios on 05/02/26.
//

import UIKit
import SnapKit

final class ClosedOrderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClosedOrderView: ViewCodeProtocol {
    func setViewHierarchy() {
    }
    
    func setViewConstraints() {
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
    }
}
