//
//  UrlConstans.swift
//  myGames
//
//  Created by YILDIRIM on 14.01.2023.
//

let gamesPath         : String = "/api/games"

let screenShotsPath   : String = "/api/games/"

func detailsPath(id:Int) -> String {
    let idString = String(id)
    return screenShotsPath + idString
}// Returns --> /api/games/id

func screenShotPathFunc(id:Int) -> String {
    let idString = String(id)
    return screenShotsPath + idString + "/screenshots"
}// returns  -> /api/games/id/screenshots



let apiKey            : String = "key"
let page              : String = "page"
 
let baseScheme        : String = "https"
let baseHost          : String = "api.rawg.io"
