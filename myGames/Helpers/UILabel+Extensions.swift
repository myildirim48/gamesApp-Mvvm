//
//  UILabel+Extensions.swift
//  myGames
//
//  Created by YILDIRIM on 18.01.2023.
//

import Foundation
import UIKit

extension UILabel {
    func addShadow() {
        layer.shadowOffset = CGSize(width: 2.5, height: 1.5)
             layer.shadowOpacity = 0.3
             layer.shadowRadius = 1
        layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
