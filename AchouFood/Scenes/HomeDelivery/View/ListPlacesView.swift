//
//  ListPlacesView.swift
//  AchouFood
//
//  Created by Arthur Rios on 04/11/25.
//

import UIKit
import SnapKit

class ListPlacesView: UIView {
    private var allPlaces: [Place] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.reuseIdentifier)
        tableView.rowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.labelXs
        view.textColor = Color.redDark
        view.text = "RESTAURANTES PERTO DE VOCÊ"
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
            make.leading.trailing.equalToSuperview().offset(20.0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
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
        tableView.reloadData()
    }
}

extension ListPlacesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.reuseIdentifier, for: indexPath) as! PlaceCell
        cell.setup(allPlaces[indexPath.row])
        return cell
    }
}

extension ListPlacesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
