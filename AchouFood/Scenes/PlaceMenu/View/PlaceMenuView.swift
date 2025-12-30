//
//  PlaceMenuView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 26/12/25.
//

import UIKit
import SnapKit
import Kingfisher

struct PlaceMenuConstants {
    static let imageSize = 36.0
    static let imageCorner = 8.0
    static let imageBorder = 1.0
    static let imagePadding = 16.0
}

class PlaceMenuView: UIView {
    
    var onBackButtonTapped: (() -> Void)?
    var place: Place?
    
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
    
    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.label2Xs
        view.textColor = Color.gray500
        view.text = "CARDÁPIO"
        return view
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleSm
        view.textColor = Color.gray500
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray100
        return view
    }()
    
    private lazy var menuSectionView = MenuSectionsView()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
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
    
    private func loadImage(with urlString: String) {
        if let url = URL(string: urlString) {
            placeImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.3))]
            )
        }
    }
}

extension PlaceMenuView {
    func setup(place: Place) {
        self.place = place
        self.subTitleLabel.text = place.restaurantName
        loadImage(with: place.imageUrl)
        menuSectionView.setup(menuItens: place.menu ?? [])
        tableView.reloadData()
    }
}

extension PlaceMenuView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(backButton)
        addSubview(contentView)
        addSubview(placeImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        contentView.addSubview(menuSectionView)
        contentView.addSubview(tableView)
    }
    
    func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Metrics.medium)
            make.leading.equalToSuperview().offset(PlaceDetailConstants.padding)
            make.size.equalTo(PlaceDetailConstants.backImageSize)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(Metrics.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        placeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.leading.equalTo(backButton.snp.trailing).offset(PlaceMenuConstants.imagePadding)
            make.size.equalTo(PlaceMenuConstants.imageSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(Metrics.small)
            make.top.equalTo(placeImageView.snp.top)
            make.trailing.equalToSuperview().inset(Metrics.medium)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(Metrics.small)
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(Metrics.medium)
        }
        
        menuSectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metrics.medium)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(menuSectionView.snp.bottom).offset(20.0)
            make.leading.trailing.bottom.equalToSuperview().inset(20.0)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray200
        contentView.layer.cornerRadius = Metrics.medium
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.layer.masksToBounds = true
        placeImageView.layer.cornerRadius = PlaceMenuConstants.imageCorner
        placeImageView.layer.borderWidth = PlaceMenuConstants.imageBorder
        placeImageView.layer.borderColor = Color.gray100.cgColor
    }
}

extension PlaceMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return place?.menu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = "teste"
        cell.backgroundColor = .clear
        return cell
    }
}

extension PlaceMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

