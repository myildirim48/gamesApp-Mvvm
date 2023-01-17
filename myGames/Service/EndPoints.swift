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
    
    static func getURLQueryBase(pageNumber number : Int = 1) -> [URLQueryItem]{
        return [URLQueryItem(name: apiKey, value: SecretKey.key),
                URLQueryItem(name: page, value: "\(number)")]
    }
    
    static func getGamesbyDate(category: gamesBetweenDates = .lastThirtyDaysReleased, pageNumber: Int = 1, dateFrom: String, dateTo: String) -> EndPoints{
        switch category {
        case .lastThirtyDaysReleased:
            return EndPoints(path: gamesPath,
                             queryItems: getURLQueryBase(pageNumber: pageNumber) +
                             [URLQueryItem(name: "dates", value: dateFrom + "," + dateTo),
                              URLQueryItem(name: "ordering", value: "released")])
        case .bestOf2022:
            return EndPoints(path: gamesPath,
                             queryItems: getURLQueryBase(pageNumber: pageNumber) +
                             [URLQueryItem(name: "dates", value: dateFrom + "," + dateTo),
                              URLQueryItem(name: "ordering", value: "ratings_count")])
        }
    }
        static func getAlltimeBest(pageNumber: Int = 1 ) -> EndPoints {
        return EndPoints(path: gamesPath,
                         queryItems: getURLQueryBase(pageNumber: pageNumber) +
                         [URLQueryItem(name: "ordering", value: "ratings_count")])
    }
    
    
}
