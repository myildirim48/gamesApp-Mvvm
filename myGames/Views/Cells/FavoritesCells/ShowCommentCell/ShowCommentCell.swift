//
//  ShowCommentCell.swift
//  myGames
//
//  Created by YILDIRIM on 24.01.2023.
//

import UIKit

class ShowCommentCell: UITableViewCell {

    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    
    let coreData = CoreDataManager.shared
    private var gamesFromCoreData = [MyGames]()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        commentView.layer.cornerRadius = 10
        commentView.clipsToBounds = true
        
    }
    
    func fetchData(id:Int) {
        gamesFromCoreData = coreData.retrieveFromCoreData()
        let idToString = String(id)
        gamesFromCoreData.forEach { game in
           if  game.id == idToString{
                commentLabel.text = game.commentText
               commentDateLabel.text = DataTransform.shared.dateToString(game.commentDate ?? Date())
               commentView.isHidden = false
           }
        }
    }
}
