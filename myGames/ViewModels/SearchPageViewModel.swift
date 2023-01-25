//
//  SearchViewModel.swift
//  myGames
//
//  Created by YILDIRIM on 25.01.2023.
//

import Foundation
class SearchPageViewModel {
    var searchedData: ((GameDataModel)->Void)?
    var showErrorView: ((String) -> Void)?

    func searchGames(with searchText:String,page:Int) {
        Responses.shared.searchGames(searchQuery: searchText, page: page) { [weak self] search in
            switch search {
            case .success(let success):
                DispatchQueue.main.async {
                    self?.searchedData?(success)
                }
            case .failure(let failure):
                self?.showErrorView?(failure.localizedDescription)
            }
        }
    }
}
