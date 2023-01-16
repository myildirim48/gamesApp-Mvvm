//
//  GameModel.swift
//  myGames
//
//  Created by YILDIRIM on 14.01.2023.
//

import Foundation
// MARK: - GamesModel
struct GameDataModel: Codable {
    let count: Int
    let results: [GameDataModelResult]
}

// MARK: - Result
struct GameDataModelResult: Codable {
    let name: String?
    let released: String?
    let backgroundImage: String
    let metacritic: Int?
    let id: Int
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case name,released,metacritic,id,genres
        case backgroundImage = "background_image"
    }
}

//MARK: - Genres
struct Genre: Codable {
    let id: Int
    let name: String
}