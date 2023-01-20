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

    private var tableViewCellid = "DetailsTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchScreenShots(gameid: gameIdDetails)
    }
    private func setupTableView(){
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(.init(nibName: tableViewCellid, bundle: nil), forCellReuseIdentifier: tableViewCellid)
    }
    
    func fetchScreenShots(gameid:Int){
         Responses.shared.fetcScreenShots(gameId: gameid) { screenShots in
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
}

extension DetailsPageController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = detailsTableView.dequeueReusableCell(withIdentifier: tableViewCellid, for: indexPath) as! DetailsTableViewCell
            cell.screenShotArr = screenShotsArr
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return view.frame.height/3
    }
}

