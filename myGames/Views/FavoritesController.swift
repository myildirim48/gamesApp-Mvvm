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
    private var gameArr = [MyGames]()
        private let viewModel = FavoritesPageViewModel()
    override func viewWillAppear(_ animated: Bool) {
        favoritesAiv.startAnimating()
        favoritesTableView.isHidden = true
        refreshData()
    }
    
    func refreshData() {
        gameArr = coreManager.retrieveFromCoreData()
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
        gameArr.forEach { gameID in
            if let id = gameID.id {
                fetchFavoritesGames(gameid: id)
            }
        }
    }
    
    //Fetch with api
    private func fetchFavoritesGames(gameid:String) {
        favGamesArr = []
        viewModel.fectFavorite(with: gameid)
        viewModel.searchedData={ data in
            DispatchQueue.main.async {
                self.favGamesArr.append(data)
                self.favoritesTableView.reloadData()
                self.favoritesTableView.isHidden = false
                self.favoritesAiv.stopAnimating()
            }
        }
        viewModel.showErrorView = { err in
            self.showAlert(title: "Error", message: err)
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
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let gameDetailPage = mainStoryBoard.instantiateViewController(withIdentifier: "gameDetailPage") as? DetailsPageController else {
            return
        }
        guard let gameId = favGamesArr[indexPath.item].id else { return }
        
        gameDetailPage.gameIdDetails = gameId
        navigationController?.navigationBar.isHidden = false
        self.navigationController!.pushViewController(gameDetailPage, animated: true)
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
