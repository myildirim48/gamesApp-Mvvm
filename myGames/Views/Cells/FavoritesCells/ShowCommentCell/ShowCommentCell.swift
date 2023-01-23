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
    override func awakeFromNib() {
        super.awakeFromNib()
        commentView.layer.cornerRadius = 10
        commentView.clipsToBounds = true
    }
}
