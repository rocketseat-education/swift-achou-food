//
//  UImageView+Extension.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 13/02/26.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(from urlString: String?,
                   placeHolder: UIImage? = UIImage(systemName: "photo"),
                   fadeDuration: TimeInterval = 0.3) {
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
                self.image = placeHolder
                return
        }
        
        self.kf.setImage(with: url,
                         placeholder: placeHolder,
                         options: [.transition(.fade(fadeDuration)),
                                   .cacheOriginalImage])
    }
}
