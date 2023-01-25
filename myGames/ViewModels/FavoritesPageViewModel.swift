//
//  FavoritesPageViewModel.swift
//  myGames
//
//  Created by YILDIRIM on 25.01.2023.
//

import Foundation
class FavoritesPageViewModel {
    var searchedData: ((GameDataModelResult)->Void)?
    var showErrorView: ((String) -> Void)?
    
    func fectFavorite(with id:String) {
        guard let gameID = Int(id) else { return }
        
        Responses.shared.fetchFavoriteGames(gameId: gameID) { [weak self] gameFav in
            switch gameFav {
            case .success(let game):
                DispatchQueue.main.async {
                    self?.searchedData?(game)
                }
            case .failure(let err):
                self?.showErrorView?(err.localizedDescription)
            }
        }
    }
}
