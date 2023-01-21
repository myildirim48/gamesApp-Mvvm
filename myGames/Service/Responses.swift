//
//  Responses.swift
//  myGames
//
//  Created by YILDIRIM on 15.01.2023.
//

import Foundation
class Responses {
    static let shared = Responses()
    
    //Fetching all time best games
    func fetchAllTimeBest(pageNumber : Int,completion:@escaping(Result<GameDataModel,Error>) ->() ) {
        GameNetwork.shared.networkRequest(request: EndPoints.getAlltimeBest(pageNumber: pageNumber), completion: completion)
    }
    
    //Fetch besf of 2022
    func fetchBestof2022(pageNumber: Int,completion: @escaping(Result<GameDataModel,Error>) -> () ) {
        GameNetwork.shared.networkRequest(request: EndPoints.getGamesbyDate(category: .bestOf2022, pageNumber: pageNumber, dateFrom: "2022-01-01", dateTo: "2022-12-31"), completion: completion)
    }
    
    //Fetch released in last 30 days
    
    func fetchInLast30Days(pageNumber: Int, dateFrom:String, dateTo:String, completion: @escaping(Result<GameDataModel,Error>) -> ()) {
       GameNetwork.shared.networkRequest(request: EndPoints.getGamesbyDate(category: gamesBetweenDates.lastThirtyDaysReleased, pageNumber: pageNumber, dateFrom:dateFrom , dateTo: dateTo), completion: completion)
    }
    
    //Fetch metacritic +90
    
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
    
}
