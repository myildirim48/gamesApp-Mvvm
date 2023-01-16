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
}
