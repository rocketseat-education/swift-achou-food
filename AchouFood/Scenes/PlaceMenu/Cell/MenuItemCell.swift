//
//  MenuItemCell.swift
//  AchouFood
//
//  Created by Arthur Rios on 22/01/26.
//

import UIKit
import SnapKit
import Kingfisher

struct MenuItemCellConstants {
    static let cellHeight = 100
}

class MenuItemCell: UITableViewCell {
    
    static let identifier: String = "MenuItemCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuItemCell: ViewCodeProtocol {
    func setViewHierarchy() {
        <#code#>
    }
    
    func setViewConstraints() {
        <#code#>
    }
    
    func setViewConfigs() {
        backgroundColor = Color.gray100
        selectionStyle = .none
    }
}
