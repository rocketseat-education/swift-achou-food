//
//  ListPlacesView.swift
//  AchouFood
//
//  Created by Arthur Rios on 04/11/25.
//

import UIKit
import SnapKit

struct ListViewConstants {
    static let rowHeight = 80.0
    static let marginSize = 20.0
    static let topTableView = 4.0
    static let nearestPlaces = "home.nearest.places"
}

class ListPlacesView: UIView {
    private var allPlaces: [Place] = []
    private var filteredPlaces: [Place] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.reuseIdentifier)
        tableView.rowHeight = ListViewConstants.rowHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = Color.gray100
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.labelXs
        view.textColor = Color.redDark
        view.text = ListViewConstants.nearestPlaces.localized
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListPlacesView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(titleLabel)
        addSubview(tableView)
    }
    
    func setViewConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(ListViewConstants.marginSize)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ListViewConstants.topTableView)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray100
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ListPlacesView {
    public func showList(with placeList: [Place]) {
        self.allPlaces = placeList
        self.filteredPlaces = placeList
        tableView.reloadData()
    }
    
    public func filter(by text: String) {
        if text.isEmpty {
            filteredPlaces = allPlaces
        } else {
            filteredPlaces = allPlaces.filter { place in
                place.restaurantName.lowercased().contains(text.lowercased())
            }
        }
        tableView.reloadData()
    }
}

extension ListPlacesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.reuseIdentifier, for: indexPath) as! PlaceCell
        cell.setup(filteredPlaces[indexPath.row])
        return cell
    }
}

extension ListPlacesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
