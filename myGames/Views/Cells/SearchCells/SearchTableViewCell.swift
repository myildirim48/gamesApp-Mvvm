//
//  SearchCell.swift
//  myGames
//
//  Created by YILDIRIM on 21.01.2023.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchCellAiv: UIActivityIndicatorView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var releasedDateValue: UILabel!
    @IBOutlet weak var searchNameLabel: UILabel!
    @IBOutlet weak var releasedDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    private func setupUI() {
        searchNameLabel.addShadow()
        releasedDateLabel.text = releasedLabelConst
        searchImageView.layer.cornerRadius = 10
        searchView.layer.cornerRadius = 10
    }
    
    var searchGameResult: GameDataModelResult? {
        didSet {
            if let data = searchGameResult {
                
                if let imgUrl = data.backgroundImage{
                    searchImageView.kf.setImage(with: URL(string: imgUrl))
                }
            
                releasedDateValue.text = data.released
                searchNameLabel.text = data.name
                searchCellAiv.stopAnimating()
            }
        }
    }
    
}
