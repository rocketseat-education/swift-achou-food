//
//  OpenOrderView.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 03/02/26.
//

import UIKit
import SnapKit

class OpenOrderView: UIView {
    
    private var sections = ["PEDIDOS DE", "ITENS", "OBSERVAÇÃO"]
    private var place: Place?
    var orderButtonTapped: (() -> Void)?
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(HeaderOrderCell.self, forCellReuseIdentifier: HeaderOrderCell.reuseIdentifier)
        view.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.reuseIdentifier)
        view.register(OrderInputCell.self, forCellReuseIdentifier: OrderInputCell.reuseIdentifier)
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.sectionHeaderHeight = 15
        view.estimatedSectionHeaderHeight = 15
        view.rowHeight = 104
        view.contentInset.bottom = 104
        return view
    }()
    
    private lazy var confirmOrderDetailsView: ConfirmOrderDetailsView = {
        let view = ConfirmOrderDetailsView()
        view.setup(itens: "0 ITEMS", total: "R$ 0,00")
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        buildLayout()
        bindActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindActions() {
        confirmOrderDetailsView.orderButtonTapped = { [weak self] in
            self?.orderButtonTapped?()
        }
    }
}

extension OpenOrderView {
    public func setup(place: Place?) {
        self.place = place
        tableView.reloadData()
        self.confirmOrderDetailsView.setup(itens: OrderManager.shared.qtdItens(),
                                           total: OrderManager.shared.totalOrder())
    }
}

extension OpenOrderView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(tableView)
        addSubview(confirmOrderDetailsView)
    }
    
    func setViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
        confirmOrderDetailsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.medium)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Metrics.medium)
            make.height.equalTo(84.0)
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
        
        confirmOrderDetailsView.layer.masksToBounds = true
        confirmOrderDetailsView.layer.cornerRadius = 18
        confirmOrderDetailsView.layer.borderWidth = 1.5
        confirmOrderDetailsView.layer.borderColor = Color.gray100.cgColor
    }
}

extension OpenOrderView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return place == nil ? 0 : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 || section == 2) ? 1 : OrderManager.shared.size()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderOrderCell.reuseIdentifier,
                                                     for: indexPath) as! HeaderOrderCell
            if let place = self.place {
                cell.setup(place)
                return cell
            }
        }
        
        if indexPath.section == 2 {
            let inputCell = tableView.dequeueReusableCell(withIdentifier: OrderInputCell.reuseIdentifier,
                                                          for: indexPath) as! OrderInputCell
            return inputCell
        }
        
        let items = OrderManager.shared.getItems()
        var item = items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseIdentifier, for: indexPath)
                   as? MenuItemCell
        
        cell?.setup(item)
        
        cell?.handleAddItem = { [weak self] in
            guard let self = self else { return }
            
            item.selectedCount += 1
            OrderManager.shared.setItem(menuItem: item)
            
            if let currentCell = self.tableView.cellForRow(at: indexPath) as? MenuItemCell {
                currentCell.updtateCount(item.selectedCount)
            }
            
            self.confirmOrderDetailsView.setup(itens: OrderManager.shared.qtdItens(),
                                               total: OrderManager.shared.totalOrder())
        }
        
        cell?.handleRemoveItem = { [weak self] in
            guard let self = self else { return }
            
            guard item.selectedCount > 0 else {
                OrderManager.shared.setItem(menuItem: item)
                return
            }
            
            item.selectedCount -= 1
            OrderManager.shared.setItem(menuItem: item)
            
            if let currentCell = self.tableView.cellForRow(at: indexPath) as? MenuItemCell {
                currentCell.updtateCount(item.selectedCount)
            }
            
            self.confirmOrderDetailsView.setup(itens: OrderManager.shared.qtdItens(),
                                               total: OrderManager.shared.totalOrder())
        }
       
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
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
