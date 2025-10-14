//
//  Untitled.swift
//  AchouFood
//
//  Created by Arthur Rios on 14/10/25.
//

import Foundation

public protocol ViewCodeProtocol {
    func setViewHierarchy()
    func setViewConstraints()
    func setViewConfigs()
    func buildLayout()
}

public extension ViewCodeProtocol {
    func buildLayout() {
        setViewHierarchy()
        setViewConstraints()
        setViewConfigs()
    }
    
    func setViewConfigs() {
        /* Empty intentionally */
    }
}
