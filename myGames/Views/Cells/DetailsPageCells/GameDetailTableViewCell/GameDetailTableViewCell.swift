//
//  GameDetailTableViewCell.swift
//  myGames
//
//  Created by YILDIRIM on 21.01.2023.
//
import Foundation
import UIKit
import WebKit

class GameDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameDetailCellView: UIView!
    @IBOutlet weak var metacriticBtn: UIButton!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releasedDate: UILabel!
    @IBOutlet weak var parentPlatformslabel: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var publishers: UILabel!
    @IBOutlet weak var gameName: UILabel!
    
    @IBOutlet weak var platformLabel: UILabel!
    
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapgesture()
        setupUI()
    }
    
    private func setupUI() {
        genresLabel.text = genresLabelConst
        platformLabel.text = platformLabelConst
        websiteLabel.text = websiteLabelConst
        releasedLabel.text = releasedLabelConst
        gameName.addShadow()

    }
    
    func addTapgesture() {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        website.addGestureRecognizer(tapLabel)

    }
    
   @objc func tapFunction(sender:UITapGestureRecognizer) {
       guard let url = URL(string: gameDetails?.website ?? "") else {
         return
       }
       UIApplication.shared.open(url)
   }
    
    var gameDetails : GameDetails? {
        didSet{
            if let gameData = gameDetails {
                metacriticBtn.titleLabel?.text = String(gameData.metacritic)
                
                if gameData.descriptionRaw != " " {
                    descriptionLabel.text = gameData.descriptionRaw
                }else {
                    descriptionLabel.text = " "
                }
                
                gameName.text = gameData.name
                releasedDate.text = gameData.released
                
                website.text = gameData.website
                
                let publisData = gameData.publishers.map{$0.name}.joined(separator: ", ")
                publishers.text = publisData
                
                let genresData = gameData.genres.map { $0.name ?? "" }.joined(separator: ", ")
                genres.text = genresData
                
                let parentPlatforms = gameData.parentPlatforms.map { $0.platform.name }.joined(separator: ", ")
                parentPlatformslabel.text = parentPlatforms
            }
        }
    }
    
}
