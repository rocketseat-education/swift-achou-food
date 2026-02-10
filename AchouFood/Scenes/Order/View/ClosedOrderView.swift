//
//  ClosedOrderView.swift
//  AchouFood
//
//  Created by Arthur Rios on 05/02/26.
//

import UIKit
import SnapKit

final class ClosedOrderView: UIView {
    
    private var place: Place?
    
    private lazy var orderSuccess = OrderSuccessBanner()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TotalOrderCell.self, forCellReuseIdentifier: TotalOrderCell.reuseIdentifier)
        tableView.register(OrderItemCell.self, forCellReuseIdentifier: OrderItemCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
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

extension ClosedOrderView {
    func setup(place: Place) {
        self.place = place
        orderSuccess.setup(placeName: place.restaurantName)
    }
}

extension ClosedOrderView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(orderSuccess)
        addSubview(tableView)
    }
    
    func setViewConstraints() {
        orderSuccess.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Metrics.medium)
            make.height.equalTo(96.0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(orderSuccess.snp.bottom).offset(Metrics.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
        
        orderSuccess.clipsToBounds = true
        orderSuccess.layer.cornerRadius = 10.0
    }
}

extension ClosedOrderView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 14.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            let label = UILabel()
            label.font = Typography.label2Xs
            label.textColor = Color.gray500
            label.text = "EM ANDAMENTO"
            return label
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

extension ClosedOrderView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : OrderManager.shared.size()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalOrderCell.reuseIdentifier, for: indexPath) as? TotalOrderCell
            
            if let place = place {
                cell?.setup(with: place,
                            itemsQtt: OrderManager.shared.qttItems(),
                            total: OrderManager.shared.totalOrder()
                )
            }
            
            return cell ?? UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderItemCell.reuseIdentifier, for: indexPath) as? OrderItemCell
        
        let items = OrderManager.shared.getItems()
        
        cell?.setup(with: items[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
}
