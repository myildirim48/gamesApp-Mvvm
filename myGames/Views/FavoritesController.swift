//
//  FavoritesController.swift
//  myGames
//
//  Created by YILDIRIM on 23.01.2023.
//

import UIKit
import CoreData

class FavoritesController: UIViewController {

    @IBOutlet weak var favoritesAiv: UIActivityIndicatorView!
    @IBOutlet weak var favoritesTableView: UITableView!
    private var favCellID = "SearchTableViewCell"
    
    private var favGamesArr : [GameDataModelResult] = []
    
    private let coreManager = CoreDataManager.shared
    private var idArray = [String]()
        
    override func viewWillAppear(_ animated: Bool) {
        favoritesAiv.startAnimating()
        favoritesTableView.isHidden = true
        refreshData()
    }
    
    func refreshData() {
        idArray = coreManager.retrieveFromCoreData()
        fetchGamesFromCoreData()
        setupTableView()
    }
    
    private func setupTableView(){
        favoritesTableView.register(.init(nibName: favCellID, bundle: nil), forCellReuseIdentifier: favCellID)
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
    
    private func fetchGamesFromCoreData(){
        favGamesArr = []
        idArray.forEach { gameID in
            fetchFavoritesGames(gameid: gameID)
        }
    }
    
    //Fetch with api
    private func fetchFavoritesGames(gameid:String) {
        favGamesArr = []
        guard let gameIdInt = Int(gameid) else { return }
        Responses.shared.fetchFavoriteGames(gameId: gameIdInt) { gameDetail in
            switch gameDetail {
            case .success(let detailData):
                DispatchQueue.main.async {
                    self.favGamesArr.append(detailData)
                    self.favoritesTableView.reloadData()
                    self.favoritesTableView.isHidden = false
                    self.favoritesAiv.stopAnimating()
                }
            case .failure(let err):
                self.showAlert(title: "Error", message: err.localizedDescription)
            }
        }
    }
    
    private func showAlert(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        self.present(alertController, animated: true)
    }

}

extension FavoritesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension FavoritesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favGamesArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: favCellID, for: indexPath) as! SearchTableViewCell
        let data = favGamesArr[indexPath.item]
            cell.searchGameResult = data
        favoritesAiv.stopAnimating()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 4
    }
}
