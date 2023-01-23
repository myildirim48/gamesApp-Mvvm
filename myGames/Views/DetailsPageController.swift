//
//  DetailsPageController.swift
//  myGames
//
//  Created by YILDIRIM on 19.01.2023.
//

import Foundation
import UIKit

class DetailsPageController: UIViewController {
    
    @IBOutlet weak var detailAiv: UIActivityIndicatorView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    var gameIdDetails : Int = 0
    
    private var screenShotsArr : [ScreenshotResult] = []
    private var gameDetaiLData : GameDetails?

    private var tableViewCellid = "DetailsTableViewCell"
    private var detailTableviewCell = "GameDetailTableViewCell"
    private var writeCommentCellID = "WriteCommentCell"
    private var commentCellId = "ShowCommentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchScreenShots(gameid: gameIdDetails)
        fetchGameDetail(gameId: gameIdDetails)
    }
    private func setupTableView(){
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(.init(nibName: tableViewCellid, bundle: nil), forCellReuseIdentifier: tableViewCellid)
        detailsTableView.register(.init(nibName: detailTableviewCell, bundle: nil), forCellReuseIdentifier: detailTableviewCell)
        detailsTableView.register(.init(nibName: writeCommentCellID, bundle: nil), forCellReuseIdentifier: writeCommentCellID)
        detailsTableView.register(.init(nibName: commentCellId, bundle: nil), forCellReuseIdentifier: commentCellId)
    }
    
    func fetchScreenShots(gameid:Int){
         Responses.shared.fetchScreenShots(gameId: gameid) { screenShots in
             switch screenShots {
             case .success(let result):
                 DispatchQueue.main.async {
                     self.screenShotsArr = result.results
                     self.setupTableView()
                     self.detailAiv.stopAnimating()
                 }
              case .failure(let err):
                 self.showALert(title: "Error", message: err.localizedDescription)
             }
         }
     }
    
    func fetchGameDetail(gameId: Int) {
        Responses.shared.fetchGameDetails(gameId: gameId) { gameDetail in
            switch gameDetail {
            case .success(let detailData):
                DispatchQueue.main.async {
                    self.gameDetaiLData = detailData
                    self.navigationItem.title = self.gameDetaiLData?.name
                }
            case .failure(let err):
                self.showALert(title: "Error", message: err.localizedDescription)
            }
        }
    }
    private func showALert(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        self.present(alertController, animated: true)
    }
}

extension DetailsPageController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = detailsTableView.dequeueReusableCell(withIdentifier: tableViewCellid, for: indexPath) as! DetailsTableViewCell
            cell.screenShotArr = screenShotsArr
            return cell
        }else if indexPath.item == 1{
            let detailCell = detailsTableView.dequeueReusableCell(withIdentifier: detailTableviewCell, for: indexPath) as! GameDetailTableViewCell
            detailCell.gameDetails = gameDetaiLData
            return detailCell
        }else if indexPath.item == 2 {
            let writeCommenCell = detailsTableView.dequeueReusableCell(withIdentifier: writeCommentCellID, for: indexPath) as! WriteCommentCell
            writeCommenCell.gameIDForComment = gameIdDetails
            return writeCommenCell
        }else{
            let commentCell = detailsTableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! ShowCommentCell
            
            return commentCell
        }
           
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.item == 3 && editingStyle == .delete{
        
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.frame.height/3
        }
        return UITableView.automaticDimension
    }
}

