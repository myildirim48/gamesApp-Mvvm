//
//  SearchController.swift
//  myGames
//
//  Created by YILDIRIM on 21.01.2023.
//

import Foundation
import UIKit
class SearchController: UIViewController{
    @IBOutlet weak var messagelabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchPageAiv: UIActivityIndicatorView!
    @IBOutlet weak var searchTableView: UITableView!
    
    private var searchCellID = "SearchTableViewCell"
    private var searchedGames : GameDataModel?
    private var searchedTotalData : Int = 0
    private var isPagination : Bool = false
    private var searchPageNum : Int = 0
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = searchConst
        self.setupTableView()
        if searchedTotalData == 0 {
            searchTableView.isHidden = true
            messagelabel.isHidden = false
            messagelabel.text = "Search something..."
            searchPageAiv.stopAnimating()
        }
        searchField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        self.searchPageAiv.startAnimating()
        messagelabel.isHidden = true
        self.searchedGames?.results = []
        searchTableView.reloadData()
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.getSearchGames(searchText: textField.text!, page: 1)
        })
        
    }
    
    private func setupTableView() {
        searchTableView.register(.init(nibName: searchCellID, bundle: nil), forCellReuseIdentifier: searchCellID)
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    private func getSearchGames(searchText:String,page:Int) {
        Responses.shared.searchGames(searchQuery: searchText, page: page) { searchRes in
            switch searchRes {
            case .success(let success):
                DispatchQueue.main.async {
                    if self.searchedGames?.count ?? 0 > 0 {
                        self.searchedGames?.results += success.results
                        self.isPagination = false
                        self.searchTableView.reloadData()
                        self.searchPageAiv.stopAnimating()
                        self.searchTableView.isHidden = false

                    }else {
                        self.searchedGames = success
                        self.searchedTotalData = success.count
                        self.searchTableView.reloadData()
                        self.searchPageAiv.stopAnimating()
                        self.searchTableView.isHidden = false
                    }
                }
            case .failure(let failure):
                print("Error at searchController",failure.localizedDescription)
            }
        }
        
    }
}

extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
    guard let gameDetailPage = mainStoryBoard.instantiateViewController(withIdentifier: "gameDetailPage") as? DetailsPageController else {
        return
    }
    guard let gameId = searchedGames?.results[indexPath.item].id else { return }

    gameDetailPage.gameIdDetails = gameId
    navigationController?.pushViewController(gameDetailPage, animated: true)
    }
}

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberofSection = searchedGames?.results.count else { return 1}
        return numberofSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: searchCellID, for: indexPath) as! SearchTableViewCell
        
        if let games = searchedGames?.results[indexPath.item] {
            cell.searchGameResult = games
        }
        
        
        if let totalFetchedGamesData = searchedGames?.results.count {
            if indexPath.item == totalFetchedGamesData - 1  && !isPagination &&  totalFetchedGamesData <= searchedTotalData {
                print(indexPath.self)
                
                isPagination = true
                searchPageNum += 1
                getSearchGames(searchText: searchField.text ?? "", page: searchPageNum)
            }
        }
            

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 4
    }
}
