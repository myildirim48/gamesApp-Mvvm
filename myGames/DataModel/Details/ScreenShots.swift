//
//  ScreenShots.swift
//  myGames
//
//  Created by YILDIRIM on 19.01.2023.
//

import Foundation
struct Screenshot: Codable {
    let count: Int
    let results: [ScreenshotResult]
}

// MARK: - Result
struct ScreenshotResult: Codable {
    let id: Int
    let image: String

    enum CodingKeys: String, CodingKey {
        case id, image
    }
}
