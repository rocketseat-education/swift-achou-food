//
//  PlaceCell.swift
//  AchouFood
//
//  Created by Arthur Rios on 04/11/25.
//

import UIKit
import SnapKit
import Kingfisher

class PlaceCell: UITableViewCell {
    
    static let reuseIdentifier: String = "PlaceCell"

    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.tintColor = Color.gray100
        return view
    }()
    
    private lazy var placeNameLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleMd
        view.textColor = .black
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodyXs
        view.textColor = .black
        view.numberOfLines = 1
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadImage(with urlString: String) {
        if let url = URL(string: urlString) {
            placeImageView.kf.setImage(with: url,
                                       placeholder: UIImage(systemName: "photo"),
                                       options: [.transition(.fade(0.3))]
            )
        }
    }
}

extension PlaceCell {
    func setup(_ place: Place) {
        placeNameLabel.text = place.restaurantName
        addressLabel.text = place.address
        loadImage(with: place.imageUrl)
    }
}

extension PlaceCell: ViewCodeProtocol {
    func setViewHierarchy() {
    }
    
    func setViewConstraints() {
    }
    
    func setViewConfigs() {
    }
}
