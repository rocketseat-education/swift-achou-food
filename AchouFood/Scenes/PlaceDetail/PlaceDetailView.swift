//
//  PlaceDetailView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 08/12/25.
//

import UIKit
import SnapKit

struct PlaceDetailConstants {
    static let backButtonSize = 36.6
    static let borderWidth = 2.0
}

class PlaceDetailView: UIView {
    
    var onBackButtonClicked: (() -> Void)?
    
    private lazy var backButton: UIImageView  = {
        let view = UIImageView()
        view.image = UIImage(named: "backButton")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (handleBack))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = PlaceDetailConstants.borderWidth
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.masksToBounds = true
        return view
    }()

    public init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init decoder has not been implemented")
    }
    
    @objc
    private func handleBack() {
        onBackButtonClicked?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backButton.layer.cornerRadius = backButton.frame.height / 2
    }
}

extension PlaceDetailView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(backButton)
    }
    
    func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(Metrics.medium)
            make.size.equalTo(PlaceDetailConstants.backButtonSize)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.redDark
    }
}
