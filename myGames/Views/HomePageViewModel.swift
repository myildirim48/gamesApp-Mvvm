//
//  HomePageViewmodel.swift
//  myGames
//
//  Created by YILDIRIM on 15.01.2023.
//

import Foundation

protocol HomePageViewModelDeleagate: AnyObject {
    func didUpdateData(_ data: [GameDataModelResult] )
}

class HomePageViewModel {
    weak var delegate : HomePageViewModelDeleagate?
    
//    private(set) var gameData : [GameDataModelResult] = []

    
    private var pageNumber = 1
    
    func fetchData() {
        Responses.shared.fetchAllTimeBest(pageNumber:pageNumber) { result in
            switch result {
            case .success(let successData):
                self.delegate?.didUpdateData(successData.results)
            case .failure(_):
                break
            }
        }
    }
}
