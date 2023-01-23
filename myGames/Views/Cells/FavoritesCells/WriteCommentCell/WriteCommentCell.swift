//
//  WriteCommentCell.swift
//  myGames
//
//  Created by YILDIRIM on 23.01.2023.
//

import UIKit

class WriteCommentCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var leaveCommentLabel: UILabel!
    @IBOutlet weak var commentText: UITextView!
    
    private let coreManager = CoreDataManager.shared
    var gameIDForComment : Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentText.delegate = self
        commentText.textColor = .lightGray
        commentText.text = "Leave your comment here..."
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentText.text = ""
    }
    

    @IBAction func saveButtonClicked(_ sender: Any) {
        coreManager.saveToCoreData(dataID: gameIDForComment, likedButton: true, comment: commentText.text, date: Date.now)
    }
}
