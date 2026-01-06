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

//
//  PlaceMenuView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 26/12/25.
//

import UIKit
import SnapKit
import Kingfisher

class PlaceMenuView: UIView {

    var onBackButtonTapped: (() -> Void)? = nil
    var place: Place? = nil

    // ✅ flags para evitar loop (tap -> scroll -> didScroll -> setSelected...)
    private var isProgrammaticScroll = false
    private var currentHighlightedSection: Int = 0

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

        // ✅ garante header visível
        view.sectionHeaderHeight = 32
        view.estimatedSectionHeaderHeight = 32

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
        menuSectionView.itemSelected = { [weak self] section in
            self?.scrollToSection(section)
        }
    }
}

// MARK: - Public API
extension PlaceMenuView {

    func setup(place: Place) {
        self.place = place
        self.subTitleLabel.text = place.restaurantName
        loadImage(with: place.imageUrl)

        menuSectionView.setup(menuItens: place.menu ?? [])
        tableView.reloadData()

        // estado inicial: topo + primeiro selecionado
        currentHighlightedSection = 0
        menuSectionView.setSelected(index: 0, notify: false, animated: false)
        tableView.setContentOffset(.zero, animated: false)

        // evita que conteúdo fique atrás do orderDetailsView
        tableView.contentInset.bottom = PlaceMenuConstants.orderViewHeight + PlaceMenuConstants.bottomPadding + 12
    }
}

// MARK: - Scroll Sync
private extension PlaceMenuView {

    func scrollToSection(_ section: Int) {
        guard let menu = place?.menu, menu.indices.contains(section) else { return }
        guard (place?.menu?[section].items.isEmpty == false) else { return }

        isProgrammaticScroll = true
        currentHighlightedSection = section

        // mantém highlight do menu sem disparar callback
        menuSectionView.setSelected(index: section, notify: false, animated: true)

        let indexPath = IndexPath(row: 0, section: section)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)

        // libera flag após animação
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.isProgrammaticScroll = false
        }
    }

    func updateHighlightedSectionFromScroll() {
        guard !isProgrammaticScroll else { return }

        // ponto no topo visível (considerando safe inset)
        let y = tableView.contentOffset.y + tableView.adjustedContentInset.top + 1
        let point = CGPoint(x: 8, y: y)

        if let indexPath = tableView.indexPathForRow(at: point) {
            setHighlightedSection(indexPath.section)
            return
        }

        // fallback quando topo cai no header
        setHighlightedSection(sectionAtTop(yPosition: y))
    }

    func setHighlightedSection(_ section: Int) {
        guard section != currentHighlightedSection else { return }
        currentHighlightedSection = section
        menuSectionView.setSelected(index: section, notify: false, animated: true)
    }

    func sectionAtTop(yPosition y: CGFloat) -> Int {
        guard let count = place?.menu?.count else { return 0 }
        for section in 0..<count {
            let rect = tableView.rect(forSection: section)
            if y >= rect.minY && y < rect.maxY { return section }
        }
        return 0
    }
}

// MARK: - ViewCodeProtocol
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

        // ✅ menuSections visível e fixo no topo do contentView
        menuSectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metrics.medium)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(26.0)
        }

        // ✅ order fixo no bottom
        orderDetailsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PlaceMenuConstants.tablePadding)
            make.height.equalTo(PlaceMenuConstants.orderViewHeight)
            make.bottom.equalToSuperview().inset(PlaceMenuConstants.bottomPadding)
        }

        // ✅ table entre menu e order
        tableView.snp.makeConstraints { make in
            make.top.equalTo(menuSectionView.snp.bottom).offset(PlaceMenuConstants.tablePadding)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(orderDetailsView.snp.top).offset(-12)
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

// MARK: - UITableViewDataSource
extension PlaceMenuView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return place?.menu?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return place?.menu?[section].items.count ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = indexPath.section
        let row = indexPath.row

        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseIdentifier,
                                                 for: indexPath) as? MenuItemCell

        cell?.setup(place?.menu?[section].items[row])

        cell?.handleAddItem = { [weak self] in
            guard let self = self else { return }

            self.place?.menu?[section].items[row].selectedCount += 1
            let newCount = self.place?.menu?[section].items[row].selectedCount ?? 0

            // ✅ pega a célula REAL daquele indexPath no momento do tap
            if let currentCell = self.tableView.cellForRow(at: indexPath) as? MenuItemCell {
                currentCell.updateCount(newCount)
            }

            if let item = self.place?.menu?[section].items[row] {
                OrderManager.shared.setItem(menuItem: item)
            }

            self.orderDetailsView.setup(itens: OrderManager.shared.qtdItens(),
                                        total: OrderManager.shared.totalOrder())
        }

        cell?.handleRemoveItem = { [weak self] in
            guard let self = self else { return }
            guard (self.place?.menu?[section].items[row].selectedCount ?? 0) > 0 else { return }

            self.place?.menu?[section].items[row].selectedCount -= 1
            let newCount = self.place?.menu?[section].items[row].selectedCount ?? 0

            if let currentCell = self.tableView.cellForRow(at: indexPath) as? MenuItemCell {
                currentCell.updateCount(newCount)
            }

            if let item = self.place?.menu?[section].items[row] {
                OrderManager.shared.setItem(menuItem: item)
            }

            self.orderDetailsView.setup(itens: OrderManager.shared.qtdItens(),
                                        total: OrderManager.shared.totalOrder())
        }

        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension PlaceMenuView: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === tableView else { return }
        updateHighlightedSectionFromScroll()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = Typography.labelXs
        label.textColor = Color.redDark
        label.text = place?.menu?[section].category.uppercased()
        return label
    }
}


