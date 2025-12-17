//
//  PlaceDetailView.swift
//  AchouFood
//
//  Created by Arthur Rios on 17/12/25.
//

import UIKit
import SnapKit
import MapKit
import Kingfisher
import CoreLocation

class PlaceDetailView: UIView {
    public init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlaceDetailView: ViewCodeProtocol {
    func setViewHierarchy() {
    }
    
    func setViewConstraints() {
    }
    
    func setViewConfigs() {
    }
}
