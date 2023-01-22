//
//  HomePageCell.swift
//  myGames
//
//  Created by YILDIRIM on 15.01.2023.
//

import UIKit
import Kingfisher

class HomePageCell: UICollectionViewCell {
    
    @IBOutlet weak var homepageCellView: UIView!
    @IBOutlet weak var homepageCellAiv: UIActivityIndicatorView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releadeDateLabel: UILabel!
    @IBOutlet weak var metascoreButtonValue: UIButton!
    @IBOutlet weak var genresValueLabel: UILabel!
    @IBOutlet weak var releaseDateValueLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        genresLabel.text = genresLabelConst
        releadeDateLabel.text = releasedLabelConst
        gameNameLabel.addShadow()
    }
    
    func setHomePageCell(with model: GameDataModelResult) {
        if let metaScore = model.metacritic{
            metascoreButtonValue.titleLabel?.text = String(metaScore)
        }
        gameNameLabel.text = model.name
        
        if let genre = model.genres {
            genresValueLabel.text = genre.map{$0.name ?? ""}.joined(separator: ", ")
        }


        if let imgUrl = model.backgroundImage{
            gameImageView.kf.setImage(with: URL.init(string:imgUrl))
        }
   
        releaseDateValueLabel.text = model.released
        
        
    }

}
