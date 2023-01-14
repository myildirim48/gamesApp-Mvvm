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
            components.scheme = scheme
            components.host = host
            components.path = path
            components.queryItems = queryItems
        return components.url
    }
    
    static func getURLQueryBase(pageNumber number : Int = 1) -> [URLQueryItem]{
        return [URLQueryItem(name: apiKey, value: SecretKey.key),
                URLQueryItem(name: page, value: "\(number)")]
    }
    
    
}
