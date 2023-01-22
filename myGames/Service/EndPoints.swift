//
//  EndPoints.swift
//  myGames
//
//  Created by YILDIRIM on 14.01.2023.
//

import Foundation
import UIKit

struct EndPoints {
    let path : String
    var queryItems : [URLQueryItem]
}

extension EndPoints {
    var url : URL? {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    //QueryItem basic APIKey + Page
    static func urlQueryApiKeyPage(pageNumber number : Int) -> [URLQueryItem]{
        return [URLQueryItem(name: apiKey, value: SecretKey.key),
                URLQueryItem(name: page, value: "\(number)")]
    }
    
    //Basic QueryItem with APIKEY
    static func urlQueryApikey() ->[URLQueryItem] {
        return [URLQueryItem(name: apiKey, value: SecretKey.key)]
    }
    
    static func getGamesbyDate(pageNumber: Int, dateFrom: String, dateTo: String) -> EndPoints{
            return EndPoints(path: gamesPath,
                             queryItems: urlQueryApiKeyPage(pageNumber: pageNumber) +
                             [URLQueryItem(name: "dates", value: dateFrom + "," + dateTo),
                              URLQueryItem(name: "ordering", value: "ratings_count")])
    }
    
    static func getAlltimeBest(pageNumber: Int) -> EndPoints {
        return EndPoints(path: gamesPath,
                         queryItems: urlQueryApiKeyPage(pageNumber: pageNumber) +
                         [URLQueryItem(name: "ordering", value: "ratings_count")])
    }
    static func getAlltimeBestMultiPlayer(pageNumber: Int) -> EndPoints {
        return EndPoints(path: gamesPath,
                         queryItems: urlQueryApiKeyPage(pageNumber: pageNumber) +
                         [URLQueryItem(name: "tags", value: "multiplayer")])
    }
    
    static func getMetaCriticPlus90(pageNumber: Int) -> EndPoints {
        return EndPoints(path: gamesPath, queryItems: urlQueryApiKeyPage(pageNumber: pageNumber) +
                         [URLQueryItem(name: "metacritic", value: "90,99")])
    }
    
    
    //MARK: -Details Section
    
    static func getScreenShots(gameId: Int) -> EndPoints {
        return EndPoints(path: screenShotPathFunc(id: gameId),
                         queryItems: urlQueryApikey())
    }
    
    static func getDetailsOfGame(gameId: Int) -> EndPoints {
        return EndPoints(path: detailsPath(id: gameId),
                         queryItems: urlQueryApikey())
    }
    //MARK: - Search
    
    static func searchGames(searchText: String,page: Int) -> EndPoints {
        return EndPoints(path: gamesPath, queryItems: urlQueryApiKeyPage(pageNumber: page) + [URLQueryItem(name: "search", value: searchText)])
    }
}
