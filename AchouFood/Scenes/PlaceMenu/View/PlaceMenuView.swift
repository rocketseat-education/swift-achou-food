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
    static let padding = 20.0
    static let backButtonSize = 36.0
    static let placeImageRadius = 8.0
    static let placeImageBorderWidth = 1.0
    static let placeImagePadding = 16.0
    static let placeImageSize = 36.0
    static let title = "placeMenu.title".localized
    static let sectionViewHeight = 26.0
    static let tablePadding = 20.0
    static let tableSectionHeight = 17.0
}

class PlaceMenuView: UIView {
    
    var onBackButtonTapped: (() -> Void)?
    var place: Place?
    
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
    
    private lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.label2Xs
        view.textColor = Color.gray500
        view.text = PlaceMenuConstants.title
        return view
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.titleSm
        view.textColor = Color.gray500
        view.text = PlaceMenuConstants.title
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray100
        return view
    }()
    
    private lazy var menuSections = MenuSectionsView()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.identifier)
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.sectionHeaderHeight = PlaceMenuConstants.tableSectionHeight
        view.estimatedSectionHeaderHeight = PlaceMenuConstants.tableSectionHeight
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        buildLayout()
        bindActions()
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
    
    private func bindActions() {
        menuSections.scrollTableTo = { [weak self] section in
            print("Nova seção selecionada")
        }
    }
}

extension PlaceMenuView {
    func setup(place: Place) {
        self.place = place
        self.subTitleLabel.text = place.restaurantName
        loadImage(with: place.imageUrl)
        menuSections.setup(menuItems: place.menu ?? [])
    }
}

extension PlaceMenuView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(backButton)
        addSubview(placeImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(contentView)
        contentView.addSubview(menuSections)
        contentView.addSubview(tableView)
    }
    
    func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Metrics.medium)
            make.leading.equalToSuperview().offset(PlaceMenuConstants.padding)
            make.size.equalTo(PlaceMenuConstants.backButtonSize)
        }
        
        placeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.leading.equalTo(backButton.snp.trailing).offset(PlaceMenuConstants.placeImagePadding)
            make.size.equalTo(PlaceMenuConstants.placeImageSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(Metrics.small)
            make.top.equalTo(placeImageView)
            make.trailing.equalToSuperview().inset(Metrics.medium)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(Metrics.small)
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(Metrics.medium)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(placeImageView.snp.bottom).offset(Metrics.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        menuSections.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metrics.medium)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(PlaceMenuConstants.sectionViewHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(menuSections.snp.bottom).offset(PlaceMenuConstants.tablePadding)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray200
        
        placeImageView.layer.cornerRadius = PlaceMenuConstants.placeImageRadius
        placeImageView.layer.borderWidth = PlaceMenuConstants.placeImageBorderWidth
        placeImageView.layer.borderColor = UIColor.white.cgColor
        
        contentView.layer.cornerRadius = Metrics.medium
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.clipsToBounds = true
    }
}

extension PlaceMenuView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return place?.menu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return place?.menu?[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension PlaceMenuView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = Typography.labelXs
        label.textColor = Color.redDark
        label.text = place?.menu?[section].category.uppercased()
        return label
    }
}
