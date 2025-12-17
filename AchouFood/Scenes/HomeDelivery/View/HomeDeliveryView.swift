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

struct HomeViewConstants {
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
    static let headerControlsHeight = 40.0
    static let topListView = 32.0
    static let loadinHeight = 80.0
    static let placeDetailMapHeight = 96.0
}

class HomeDeliveryView: UIView {
    
    private var selectViewMode: DisplayStyle = .list
    private var searchText: String = String()
    private var places: [Place]?
    var onSelectedPlace: ((Place) -> Void)?
    var selectedPlace: Place?
    
    private lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var headerIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: HomeViewConstants.addressIcon)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var headerTitleAddressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.label2Xs
        view.textColor = Color.gray200
        view.text = HomeViewConstants.addressTitle.localized
        return view
    }()
    
    private lazy var headerAddressLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodySm
        view.textColor = Color.gray200
        view.text = StorageManager.shared.get(forKey: HomeViewConstants.userAddressKey)
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
        view.placeholder = HomeViewConstants.findPlacesKey.localized
        view.font = Typography.bodyMd
        view.textColor = Color.gray400
        view.backgroundColor = Color.grayTransparent80p
        view.layer.borderWidth = HomeViewConstants.borderWidth
        view.layer.borderColor = UIColor.white.cgColor
        
        let icon = UIImageView(image: UIImage(systemName: HomeViewConstants.searchIcon))
        icon.tintColor = Color.gray400
        icon.contentMode = .scaleAspectFit
        
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        iconContainer.addSubview(icon)
        icon.frame = CGRect(x: 12, y: 0, width: 20, height: 20)
        
        view.leftView = iconContainer
        view.leftViewMode = .always
        view.clearButtonMode = .whileEditing
        view.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        return view
    }()
    
    private lazy var toggleView: UISegmentedControl = {
        let listImage = UIImage(named: HomeViewConstants.listIconName)
        let mapImage = UIImage(named: HomeViewConstants.mapIconName)
        
        let view = UISegmentedControl(items: [listImage as Any, mapImage as Any])
        view.selectedSegmentIndex = .zero
        view.backgroundColor = Color.redDark
        view.selectedSegmentTintColor = Color.gray100
        view.tintColor = Color.gray100
        view.layer.borderWidth = HomeViewConstants.borderWidth
        view.layer.borderColor = UIColor.white.cgColor
        view.addTarget(self, action: #selector(handleToggle), for: .valueChanged)
        return view
    }()
    
    private lazy var listView: ListPlacesView = {
        let view = ListPlacesView()
        view.onCellTouched = { [weak self] place in
            self?.onSelectedPlace?(place)
        }
        view.backgroundColor = Color.gray100
        return view
    }()
    
    private lazy var mapView: MapPlacesView = {
        let view = MapPlacesView()
        view.onPinSelected = { [weak self] place in
            self?.placeDetailMapView.isHidden = false
            self?.setPlaceDetails(with: place)
        }
        view.onPinDeselected = { [weak self] in
            self?.placeDetailMapView.isHidden = true
        }
        return view
    }()
    
    private lazy var placeDetailMapView: PlaceDetailMapView = {
        let view = PlaceDetailMapView()
        view.layer.borderColor = Color.gray100.cgColor
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderWidth = 2.0
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.isHidden = true
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
        placeDetailMapView.isHidden = true
        let pageIndex = toggleView.selectedSegmentIndex
        selectViewMode = pageIndex == 0 ? .list : .map
        let offsetX = CGFloat(pageIndex) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        showPlaces()
    }
    
    @objc
    func textDidChange(_ textField: UITextField) {
        searchText = textField.text ?? ""
        filter(by: searchText)
    }
    
    private func showPlaces() {
        guard let places = places else { return }
        if (selectViewMode == .list) {
            listView.showList(with: places)
        } else {
            mapView.showPlaces(with: places)
        }
        filter(by: searchText)
    }
    
    private func filter(by searchText: String) {
        if (selectViewMode == .list) {
            listView.filter(by: searchText)
        } else {
            mapView.filter(by: searchText)
        }
    }
    
    private func setPlaceDetails(with place: Place) {
        self.selectedPlace = place
        self.placeDetailMapView.setup(place: place)
    }
}

extension HomeDeliveryView {
    public func setup(with places: [Place]?) {
        guard let places = places else { return }
        self.places = places
        showPlaces()
    }
    
    public func startLoading() {
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    public func stopLoading() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }
}

extension HomeDeliveryView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(headerView)
        addSubview(scrollView)
        addSubview(searchTextField)
        addSubview(toggleView)
        addSubview(placeDetailMapView)
        addSubview(loadingView)
        scrollView.addSubview(contentView)
        contentView.addSubview(listView)
        contentView.addSubview(mapView)
        headerView.addSubview(headerIcon)
        headerView.addSubview(headerTitleAddressLabel)
        headerView.addSubview(headerAddressLabel)
    }
    
    func setViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(HomeViewConstants.headerHeight)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Metrics.medium)
            make.leading.trailing.equalToSuperview().inset(Metrics.medium)
        }
        
        headerIcon.snp.makeConstraints { make in
            make.size.equalTo(HomeViewConstants.iconSize)
            make.centerY.equalTo(headerView)
            make.leading.equalToSuperview()
        }
        
        headerTitleAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(headerIcon.snp.top).offset(Metrics.little)
            make.leading.equalTo(headerIcon.snp.trailing).offset(HomeViewConstants.marginSize)
            make.trailing.equalToSuperview()
        }
        
        headerAddressLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerIcon.snp.trailing).offset(HomeViewConstants.marginSize)
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
            make.height.equalTo(HomeViewConstants.headerControlsHeight)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(Metrics.medium)
            make.leading.equalTo(scrollView.snp.leading).offset(Metrics.medium)
            make.trailing.equalTo(toggleView.snp.leading).offset(-Metrics.tiny)
            make.height.equalTo(HomeViewConstants.headerControlsHeight)
        }
        
        listView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(HomeViewConstants.topListView)
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        mapView.snp.makeConstraints { make in
            make.leading.equalTo(listView.snp.trailing)
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        placeDetailMapView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(HomeViewConstants.margin)
            make.leading.trailing.equalToSuperview().inset(HomeViewConstants.margin)
            make.height.equalTo(HomeViewConstants.placeDetailMapHeight)
        }
        
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(HomeViewConstants.loadinHeight)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.redDark
        scrollView.isScrollEnabled = false
        scrollView.layer.cornerRadius = HomeViewConstants.cornerRadius
        scrollView.layer.masksToBounds = true
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
