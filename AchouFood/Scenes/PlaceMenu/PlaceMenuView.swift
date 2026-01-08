//
//  PlaceMenuView.swift
//  AchouFood
//
//  Created by Arthur Rios on 07/01/26.
//

import UIKit
import SnapKit
import Kingfisher

struct PlaceMenuConstants {
    static let backButton = "backButton"
}

class PlaceMenuView: UIView {
    
    var onBackButtonTapped: (() -> Void)?
    
    private lazy var backButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: PlaceMenuConstants.backButton)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.masksToBounds = true
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleBack() {
        onBackButtonTapped?()
    }
}

extension PlaceMenuView: ViewCodeProtocol {
    func setViewHierarchy() {
    }
    
    func setViewConstraints() {
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray200
    }
}
