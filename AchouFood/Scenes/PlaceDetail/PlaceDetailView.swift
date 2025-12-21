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

struct PlaceDetailConstants {
    static let backButtonImage = "backButton"
    static let padding = 20.0
    static let backImageSize = 36.0
}

class PlaceDetailView: UIView {
    
    var onBackButtonTapped: (() -> Void)?
    
    private lazy var backButton: UIImageView = {
        let view = UIImageView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        view.image = UIImage(named: PlaceDetailConstants.backButtonImage)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backButton.layer.cornerRadius = backButton.frame.height / 2
    }
    
    @objc
    private func handleBack() {
        onBackButtonTapped?()
    }
}

extension PlaceDetailView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(backButton)
    }
    
    func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Metrics.medium)
            make.leading.equalToSuperview().offset(PlaceDetailConstants.padding)
            make.size.equalTo(PlaceDetailConstants.backImageSize)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.redDark
    }
}
