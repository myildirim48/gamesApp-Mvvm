//
//  GameDetails.swift
//  myGames
//
//  Created by YILDIRIM on 21.01.2023.
//

import Foundation
struct GameDetails: Codable {
    let name : String
    let descriptionRaw: String
    let metacritic : Int
    let released: String
    let website: String
    let publishers: [Publisher]
    let genres: [Genre]
    let parentPlatforms: [ParentPlatform]
    
    enum CodingKeys: String, CodingKey {
        case name,metacritic,released,website,publishers,genres
        case descriptionRaw = "description_raw"
        case parentPlatforms = "parent_platforms"
    }

}

struct Publisher: Codable {
    let id: Int
    let name: String
}

struct ParentPlatform:Codable {
    let platform: Publisher
}
