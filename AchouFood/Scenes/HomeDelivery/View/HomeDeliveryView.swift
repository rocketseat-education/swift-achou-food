//
//  HomeDeliveryView.swift
//  AchouFood
//
//  Created by Arthur Rios on 20/10/25.
//

import UIKit
import SnapKit

enum DisplayStyle: Int {
    case list = 0
    case map = 1
}

struct Constants {
    static let headerHeight = 36.0
    static let cornerRadius = 20.0
    static let margin = 20.0
    static let addressIcon = "AddressIcon"
    static let addressTitle = "home.header.addressTitle"
    static let findPlacesKey = "home.find.places"
    static let userAddressKey = "userAddress"
    static let searchIcon = "magnifyingglass"
    static let listIconName = "listIcon"
    static let mapIconName = "mapIcon"
    static let iconSize = 36.0
    static let marginSize = 12.0
    static let borderWidth = 2.0
}

class HomeDeliveryView: UIView {
    
    private var selectViewMode: DisplayStyle = .list
    
    private lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var headerIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Constants.addressIcon)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var headerTitleAddressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.label2Xs
        view.textColor = Color.gray200
        view.text = Constants.addressTitle.localized
        return view
    }()
    
    private lazy var headerAddressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray200
        view.text = StorageManager.shared.get(forKey: Constants.userAddressKey)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = Color.gray100
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray100
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let view = UITextField()
        view.placeholder = Constants.findPlacesKey.localized
        view.font = Typography.bodyMd
        view.textColor = Color.gray400
        view.backgroundColor = Color.grayTransparent20p
        view.layer.borderWidth = Constants.borderWidth
        view.layer.borderColor = UIColor.white.cgColor
        
        let icon = UIImageView(image: UIImage(systemName: Constants.searchIcon))
        icon.tintColor = Color.gray400
        icon.contentMode = .scaleAspectFit
        
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        iconContainer.addSubview(icon)
        icon.frame = CGRect(x: 12, y: 0, width: 20, height: 20)
        
        view.leftView = iconContainer
        view.leftViewMode = .always
        view.clearButtonMode = .whileEditing
        view.delegate = self
        
        return view
    }()
    
    private lazy var toggleView: UISegmentedControl = {
        let listImage = UIImage(named: Constants.listIconName)
        let mapImage = UIImage(named: Constants.mapIconName)
        
        let view = UISegmentedControl(items: [listImage as Any, mapImage as Any])
        view.selectedSegmentIndex = .zero
        view.backgroundColor = Color.redDark
        view.selectedSegmentTintColor = Color.gray100
        view.tintColor = Color.gray100
        view.layer.borderWidth = Constants.borderWidth
        view.layer.borderColor = UIColor.white.cgColor
        view.addTarget(self, action: #selector(handleToggle), for: .valueChanged)
        return view
    }()
    
    private lazy var listView: ListPlacesView = {
        let view = ListPlacesView()
        view.backgroundColor = Color.gray100
        return view
    }()
    
    private lazy var mapView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray300
        return view
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchTextField.layer.cornerRadius = searchTextField.bounds.height / 2
        toggleView.layer.cornerRadius = toggleView.bounds.height / 2
        toggleView.layer.masksToBounds = true
    }
    
    @objc
    func handleToggle() {
        let pageIndex = toggleView.selectedSegmentIndex
        selectViewMode = pageIndex == 0 ? .list : .map
        let offsetX = CGFloat(pageIndex) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    private func showPlaces(_ places: [Place]) {
        if (selectViewMode == .list) {
            listView.showList(with: places)
        } else {
            //Apresentacao dos locais no map
        }
    }
}

extension HomeDeliveryView {
    public func setup(with places: [Place]?) {
        guard let places = places else { return }
        showPlaces(places)
    }
}

extension HomeDeliveryView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(headerView)
        addSubview(scrollView)
        addSubview(searchTextField)
        addSubview(toggleView)
        scrollView.addSubview(contentView)
        contentView.addSubview(listView)
        contentView.addSubview(mapView)
        headerView.addSubview(headerIcon)
        headerView.addSubview(headerTitleAddressLabel)
        headerView.addSubview(headerAddressLabel)
    }
    
    func setViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(Constants.headerHeight)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Metrics.medium)
            make.leading.trailing.equalToSuperview().inset(Metrics.medium)
        }
        
        headerIcon.snp.makeConstraints { make in
            make.size.equalTo(Constants.iconSize)
            make.centerY.equalTo(headerView)
            make.leading.equalToSuperview()
        }
        
        headerTitleAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(headerIcon.snp.top).offset(Metrics.little)
            make.leading.equalTo(headerIcon.snp.trailing).offset(Constants.marginSize)
            make.trailing.equalToSuperview()
        }
        
        headerAddressLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerIcon.snp.trailing).offset(Constants.marginSize)
            make.top.equalTo(headerTitleAddressLabel.snp.bottom).offset(Metrics.nano)
            make.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Metrics.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }
        
        toggleView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(Metrics.medium)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-Metrics.medium)
            make.height.equalTo(40)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(Metrics.medium)
            make.leading.equalTo(scrollView.snp.leading).offset(Metrics.medium)
            make.trailing.equalTo(toggleView.snp.leading).offset(-Metrics.tiny)
            make.height.equalTo(40)
        }
        
        listView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(32.0)
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        mapView.snp.makeConstraints { make in
            make.leading.equalTo(listView.snp.trailing)
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.redDark
        scrollView.isScrollEnabled = false
        scrollView.layer.cornerRadius = Constants.cornerRadius
        scrollView.layer.masksToBounds = true
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

extension HomeDeliveryView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersInRanges ranges: [NSValue], replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
