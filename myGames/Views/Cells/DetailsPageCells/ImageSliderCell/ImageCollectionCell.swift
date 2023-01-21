//
//  DetailsPageImageCell.swift
//  myGames
//
//  Created by YILDIRIM on 19.01.2023.
//

import UIKit
import Kingfisher

class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var detailsImageView: UIImageView!
         
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsImageView.layer.cornerRadius = 10
    }
     

}
