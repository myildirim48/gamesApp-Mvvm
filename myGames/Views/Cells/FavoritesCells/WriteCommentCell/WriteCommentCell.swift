//
//  WriteCommentCell.swift
//  myGames
//
//  Created by YILDIRIM on 23.01.2023.
//

import UIKit

class WriteCommentCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var writeCommentView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var leaveCommentLabel: UILabel!
    @IBOutlet weak var commentText: UITextView!
    
    private let coreManager = CoreDataManager.shared
    var gameIDForComment : Int = 0
    private var gamesArr = [MyGames]()
    private var save = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentText.delegate = self
        commentText.textColor = .lightGray
        commentText.text = "Leave your comment here..."
        
        
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if (text == "\n") {
            commentText.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentText.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        commentText.resignFirstResponder()
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        
        gamesArr = coreManager.retrieveFromCoreData()
        gamesArr.forEach { game in
            if game.id == String(gameIDForComment) {
                coreManager.deleteFromCoreData(dataID: gameIDForComment)
                save = false
                coreManager.saveToCoreData(dataID: gameIDForComment, likedButton: true, comment: commentText.text, date: Date.now)
            }
        }
        if save {
            coreManager.saveToCoreData(dataID: gameIDForComment, likedButton: true, comment: commentText.text, date: .now)
        }
    
    }
}
