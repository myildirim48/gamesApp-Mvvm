//
//  DataTransform.swift
//  myGames
//
//  Created by YILDIRIM on 16.01.2023.
//

import Foundation
class DataTransform {
    static var shared = DataTransform()
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func transformStringToDate(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: string)
        dateFormatter.string(from: date!)
        return date ?? .now
    }
}
