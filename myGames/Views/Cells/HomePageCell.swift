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
        genresLabel.text = "Genres : "
        releadeDateLabel.text = "Release Date : "
    }
    
    func setHomePageCell(with model: GameDataModelResult) {
        if let metaScore = model.metacritic{
            metascoreButtonValue.titleLabel?.text = String(metaScore)
        }
        gameNameLabel.text = model.name
        genresValueLabel.text = model.genres.map{$0.name}.joined(separator: ", ")
        gameImageView.kf.setImage(with: URL.init(string: model.backgroundImage))
        releaseDateValueLabel.text = model.released
        
        
    }

}
