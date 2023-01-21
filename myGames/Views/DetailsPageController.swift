//
//  DetailsPageController.swift
//  myGames
//
//  Created by YILDIRIM on 19.01.2023.
//

import Foundation
import UIKit

class DetailsPageController: UIViewController {
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    var gameIdDetails : Int = 0
    
    private var screenShotsArr : [ScreenshotResult] = []
    private var gameDetaiLData : GameDetails?

    private var tableViewCellid = "DetailsTableViewCell"
    private var detailTableviewCell = "GameDetailTableViewCell"
    
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
    }
    
    func fetchScreenShots(gameid:Int){
         Responses.shared.fetchScreenShots(gameId: gameid) { screenShots in
             switch screenShots {
             case .success(let result):
                 DispatchQueue.main.async {
                     self.screenShotsArr = result.results
                     self.setupTableView()
                 }
              case .failure(let err):
                 print("Error @DetailsTableViewCell",err.localizedDescription)
             }
         }
     }
    
    func fetchGameDetail(gameId: Int) {
        Responses.shared.fetchGameDetails(gameId: gameId) { gameDetail in
            switch gameDetail {
            case .success(let detailData):
                self.gameDetaiLData = detailData
            case .failure(let err):
                print("Error fetchGameDetail",err.localizedDescription)
            }
        }
    }
}

extension DetailsPageController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = detailsTableView.dequeueReusableCell(withIdentifier: tableViewCellid, for: indexPath) as! DetailsTableViewCell
            cell.screenShotArr = screenShotsArr
            return cell
        }else {
            let detailCell = detailsTableView.dequeueReusableCell(withIdentifier: detailTableviewCell, for: indexPath) as! GameDetailTableViewCell
            detailCell.gameDetails = gameDetaiLData
            return detailCell
        }
           
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.frame.height/3
        }
        return UITableView.automaticDimension
    }
}

