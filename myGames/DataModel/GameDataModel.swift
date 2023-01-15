//
//  GameModel.swift
//  myGames
//
//  Created by YILDIRIM on 14.01.2023.
//

import Foundation
// MARK: - GamesModel
struct GameDataModel: Decodable {
    let count: Int
    let results: [GameDataModelResult]
}

// MARK: - Result
struct GameDataModelResult: Decodable {
    let name: String
    let released: String
    let backgroundImage: String
    let metacritic: Int?
    let id: Int
    let genres: [Genre]
}

//MARK: - Genres
struct Genre: Codable {
    let id: Int
    let name: String
}
