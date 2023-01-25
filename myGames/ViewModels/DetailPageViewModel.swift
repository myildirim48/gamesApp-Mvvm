//
//  DetailPageViewModel.swift
//  myGames
//
//  Created by YILDIRIM on 24.01.2023.
//

import Foundation

class DetailPageViewModel {
    
    var gameDetailsVoid : ((GameDetails) -> Void)?
    var showErrorView: ((String) -> Void)?
    var screenShotsVoid : (([ScreenshotResult]) -> Void)?
    
     func fetchDetailsWithId(with id:Int) {
        Responses.shared.fetchGameDetails(gameId: id) { [weak self] screenShots in
            switch screenShots {
            case .success(let result):
                DispatchQueue.main.async {
                    self?.gameDetailsVoid?(result)
                }
             case .failure(let err):
                self?.showErrorView?(err.localizedDescription)
            }
        }
    }
    
    func fetchGameScreenShots(with id:Int) {
        Responses.shared.fetchScreenShots(gameId: id) { screenShots in
            switch screenShots {
            case .success(let result):
                DispatchQueue.main.async {
                    self.screenShotsVoid?(result.results)
                }
                
             case .failure(let err):
                self.showErrorView?(err.localizedDescription)
            }
        }
    }
    
}
