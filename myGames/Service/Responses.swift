//
//  Responses.swift
//  myGames
//
//  Created by YILDIRIM on 15.01.2023.
//

import Foundation
class Responses {
    static let shared = Responses()
    
    //MARK: - Homepage responses
    func fetchAllTimeBest(pageNumber : Int,completion:@escaping(Result<GameDataModel,Error>) ->() ) {
        GameNetwork.shared.networkRequest(request: EndPoints.getAlltimeBest(pageNumber: pageNumber), completion: completion)
    }
    
    func fetchBestof2022(pageNumber: Int,completion: @escaping(Result<GameDataModel,Error>) -> () ) {
        GameNetwork.shared.networkRequest(request: EndPoints.getGamesbyDate(pageNumber: pageNumber, dateFrom: "2022-01-01", dateTo: "2022-12-31"), completion: completion)
    }
    
    func fetchBestMultiPlayerGames(pageNumber: Int, completion: @escaping(Result<GameDataModel,Error>) -> ()) {
        GameNetwork.shared.networkRequest(request: EndPoints.getAlltimeBestMultiPlayer(pageNumber: pageNumber), completion: completion)
    }
    
    func fetchMetacritic(pageNumber: Int,completion: @escaping(Result<GameDataModel,Error>) -> ()) {
        GameNetwork.shared.networkRequest(request: EndPoints.getMetaCriticPlus90(pageNumber: pageNumber), completion: completion)
    }
    
    //MARK: - Details Responses
    
    func fetchScreenShots(gameId:Int,completion: @escaping(Result<Screenshot,Error>) -> ()) {
        GameNetwork.shared.networkRequest(request: EndPoints.getScreenShots(gameId: gameId), completion: completion)
    }
    
    func fetchGameDetails(gameId:Int,completion: @escaping(Result<GameDetails,Error>) -> ()) {
        GameNetwork.shared.networkRequest(request: EndPoints.getDetailsOfGame(gameId: gameId), completion: completion)
    }
    
    //MARK: -Search Response
    
    func searchGames(searchQuery: String,page:Int,completion: @escaping(Result<GameDataModel,Error>) -> ()) {
        GameNetwork.shared.networkRequest(request: EndPoints.searchGames(searchText: searchQuery, page: page), completion: completion)
    }
    
    func fetchFavoriteGames(gameId:Int,completion: @escaping(Result<GameDataModelResult,Error>) -> ()) {
        GameNetwork.shared.networkRequest(request: EndPoints.getDetailsOfGame(gameId: gameId), completion: completion)
    }
    }
