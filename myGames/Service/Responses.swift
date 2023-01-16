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
    func fetchAllTimeBest(pageNumber : Int,completion:@escaping((Result<GameDataModel,Error>)) ->() ) {
        GameNetwork.shared.networkRequest(request: EndPoints.getAlltimeBest(pageNumber: pageNumber), completion: completion)
    }
    
    
    
}
