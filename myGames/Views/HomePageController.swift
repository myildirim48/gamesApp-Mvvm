//
//  ViewController.swift
//  myGames
//
//  Created by YILDIRIM on 12.01.2023.
//

import UIKit

class HomePageController: UIViewController,HomePageViewModelDeleagate {
    

    @IBOutlet weak var homePageCollectionView: UICollectionView!
    
    private let viewModel = HomePageViewModel()
    
    private let cellNibNameKey = "HomePageCell"
    
    var gameResult : [GameDataModelResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        setupCollectionView()

//        viewModel.fetchData()
    }
    
    func didUpdateData(_ data: [GameDataModelResult]) {
        gameResult = data
        homePageCollectionView.reloadData()
    }
    
}

extension HomePageController {
    

    private func setupCollectionView() {
        homePageCollectionView?.register(.init(nibName: cellNibNameKey, bundle: nil), forCellWithReuseIdentifier: cellNibNameKey)
        homePageCollectionView?.dataSource = self
        homePageCollectionView?.delegate = self
    }
}

extension HomePageController : UICollectionViewDelegate {
    // TO:DO did select to detailVC
}

extension HomePageController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 5
        }else if section == 2 {
            return 0
        }else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellNibNameKey, for: indexPath) as! HomePageCell
//        cell.setHomePageCell(with: gameResult[indexPath.row])
        cell.layer.cornerRadius = 10
        
        return cell
    }
}


