//
//  OpenOrderView.swift
//  AchouFood
//
//  Created by Arthur Rios on 05/02/26.
//

import UIKit
import SnapKit

final class OpenOrderView: UIView {
    
    private var sections = ["PEDIDOS DE", "ITENS", "OBSERVAÇÃO"]
    private var place: Place?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderHeight = 15
        tableView.estimatedRowHeight = 15
        tableView.rowHeight = 104
        tableView.contentInset.bottom = 104
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OpenOrderView {
    func setup(with place: Place?) {
        tableView.reloadData()
    }
}

extension OpenOrderView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(tableView)
    }
    
    func setViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Metrics.medium)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
    }
}

extension OpenOrderView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 || section == 2) ? 1 : OrderManager.shared.size()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension OpenOrderView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = Typography.labelXs
        label.textColor = Color.gray500
        label.text = sections[section]
        return label
    }
}
