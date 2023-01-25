//
//  DetailPageViewModel.swift
//  myGames
//
//  Created by YILDIRIM on 24.01.2023.
//

import Foundation

class HomePageViewModel {
    
    var allTimeBestData: ((GameDataModel) -> Void)?
    var bestOf2022:((GameDataModel) -> Void)?
    var bestOfMulti:((GameDataModel) -> Void)?
    var metacriticData:((GameDataModel) -> Void)?
    
    var showErrorView: ((String) -> Void)?

     func fetchAllTimeBest(with pageNumber: Int) {
        Responses.shared.fetchAllTimeBest(pageNumber: pageNumber) { [weak self] allTimeBest in
            switch allTimeBest {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.allTimeBestData?(data)
                }
            case .failure(let err):
                self?.showErrorView?(err.localizedDescription)
            }
        }
    }
    
    func fetchBestOf2022(with pageNumber: Int){
        Responses.shared.fetchBestof2022(pageNumber: pageNumber) { [weak self] bestOf in
            switch bestOf {
            case .success(let best):
                DispatchQueue.main.async {
                    self?.bestOf2022?(best)
                }
            case .failure(let err):
                self?.showErrorView?(err.localizedDescription)
            }
        }
    }
    
    func fetchBestOfMultiPlayer(with pageNumber: Int){
        Responses.shared.fetchBestMultiPlayerGames(pageNumber: pageNumber) { [weak self] multiGames in
            switch multiGames {
            case .success(let gamesMulti):
                DispatchQueue.main.async {
                    self?.bestOfMulti?(gamesMulti)
                }
            case .failure(let err):
                self?.showErrorView?(err.localizedDescription)
            }
        }
    }
    
    func fetchMetacriticData(with page:Int){
        Responses.shared.fetchMetacritic(pageNumber: page) {[weak self] metacrit in
            switch metacrit {
            case .success(let metaData):
                DispatchQueue.main.async {
                    self?.metacriticData?(metaData)
                }
            case .failure(let err):
                self?.showErrorView?(err.localizedDescription)
            }
        }
    }
    
}
