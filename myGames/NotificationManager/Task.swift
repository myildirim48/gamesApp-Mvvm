//
//  Task.swift
//  myGames
//
//  Created by YILDIRIM on 25.01.2023.
//

import Foundation
struct Task: Identifiable, Codable {
  var id = UUID().uuidString
  var name: String
  var completed = false
  var reminderEnabled = false
}
