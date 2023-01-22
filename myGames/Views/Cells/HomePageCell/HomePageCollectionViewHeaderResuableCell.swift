//
//  HomePageCollectionViewHeaderResuableCell.swift
//  myGames
//
//  Created by YILDIRIM on 16.01.2023.
//

import UIKit

class HomePageCollectionViewHeaderResuableCell: UICollectionReusableView {
        
    @IBOutlet weak var headerTitleLabel: UILabel!
    
    func setup(_ title: String) {
        headerTitleLabel.text = title
        headerTitleLabel.addShadow(alpha: 0.2, opacity: 3, radius: 3)
    }
}
