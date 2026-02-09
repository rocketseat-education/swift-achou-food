//
//  ClosedOrderView.swift
//  AchouFood
//
//  Created by Arthur Rios on 05/02/26.
//

import UIKit
import SnapKit

final class ClosedOrderView: UIView {
    
    private lazy var orderSuccess = OrderSuccessBanner()
    private var place: Place?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClosedOrderView {
    func setup(place: Place) {
        self.place = place
        orderSuccess.setup(placeName: place.restaurantName)
    }
}

extension ClosedOrderView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(orderSuccess)
    }
    
    func setViewConstraints() {
        orderSuccess.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Metrics.medium)
            make.height.equalTo(96.0)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
        
        orderSuccess.clipsToBounds = true
        orderSuccess.layer.cornerRadius = 10.0
    }
}
