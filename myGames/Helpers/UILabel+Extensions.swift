//
//  UILabel+Extensions.swift
//  myGames
//
//  Created by YILDIRIM on 18.01.2023.
//

import Foundation
import UIKit
extension UILabel {
    func addShadow(alpha:CGFloat = 1,opacity: Float = 0.3,radius: CGFloat = 1) {
        layer.shadowOffset = CGSize(width: 2.5, height: 1.5)
             layer.shadowOpacity = opacity
             layer.shadowRadius = radius
        layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: alpha)
    }
}
