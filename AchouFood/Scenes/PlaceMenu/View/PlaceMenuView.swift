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
    static let rowHeight = 104.0
    static let backImageSize = 36.0
    static let padding = 20.0
    static let tablePadding = 20.0
    static let orderViewHeight = 84.0
    static let bottomPadding = 34.0
}

class PlaceMenuView: UIView {
    
    var onBackButtonTapped: (() -> Void)? = nil
    var place: Place? = nil
    var categorySelected: Int? = nil
    
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
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.reuseIdentifier)
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.rowHeight = PlaceMenuConstants.rowHeight
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var orderDetailsView: OrderDetailsView = {
        let view = OrderDetailsView()
        view.setup(itens: "0 ITEMS", total: "R$ 0,00")
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
        menuSectionView.itemSelected = { [weak self] itemSelected in
            self?.categorySelected = itemSelected
            self?.tableView.reloadData()
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
        contentView.addSubview(orderDetailsView)
    }
    
    func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Metrics.medium)
            make.leading.equalToSuperview().offset(PlaceMenuConstants.padding)
            make.size.equalTo(PlaceMenuConstants.backImageSize)
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
            make.top.equalTo(menuSectionView.snp.bottom).offset(PlaceMenuConstants.tablePadding)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        orderDetailsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PlaceMenuConstants.tablePadding)
            make.height.equalTo(PlaceMenuConstants.orderViewHeight)
            make.bottom.equalToSuperview().inset(PlaceMenuConstants.bottomPadding)
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
        
        orderDetailsView.layer.masksToBounds = true
        orderDetailsView.layer.cornerRadius = 18.0
        orderDetailsView.layer.borderWidth = 1.5
        orderDetailsView.layer.borderColor = Color.gray100.cgColor
    }
}

extension PlaceMenuView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categorySelected != nil ? 1 : (place?.menu?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = categorySelected != nil ? categorySelected! : section
        return place?.menu?[currentSection].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = categorySelected != nil ? categorySelected! : indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as? MenuItemCell
        cell?.setup(place?.menu?[currentSection].items[indexPath.row])
        cell?.handleAddItem =  { [weak self] in
            guard let self = self else { return }
            self.place?.menu?[currentSection].items[indexPath.row].selectedCount += 1
            self.tableView.reloadData()
            OrderManager.shared.setItem(menuItem: (place?.menu?[currentSection].items[indexPath.row])!)
            orderDetailsView.setup(itens: OrderManager.shared.qtdItens(), total: OrderManager.shared.totalOrder())
        }
        cell?.handleRemoveItem =  { [weak self] in
            guard let self = self else { return }
            if (self.place?.menu?[currentSection].items[indexPath.row].selectedCount == 0) { return }
            self.place?.menu?[currentSection].items[indexPath.row].selectedCount -= 1
            self.tableView.reloadData()
            OrderManager.shared.setItem(menuItem: (place?.menu?[currentSection].items[indexPath.row])!)
            orderDetailsView.setup(itens: OrderManager.shared.qtdItens(), total: OrderManager.shared.totalOrder())
        }
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
}

extension PlaceMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentSection = categorySelected != nil ? categorySelected! : section
        let view = UILabel()
        view.font = Typography.labelXs
        view.textColor = Color.redDark
        view.text = place?.menu?[currentSection].category.uppercased()
        return view
    }
}

