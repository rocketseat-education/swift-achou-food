//
//  String+Extension.swift
//  AchouFood
//
//  Created by Arthur Rios on 14/10/25.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
