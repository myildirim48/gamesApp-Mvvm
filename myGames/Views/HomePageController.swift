//
//  ViewController.swift
//  myGames
//
//  Created by YILDIRIM on 12.01.2023.
//

import UIKit

enum Sections: Int {
    case allTimeBest = 0
//    case TrendingTv = 1
//    case Popular = 2
//    case UpComing = 3
//    case TopRated = 4
//
}

class HomePageController: UIViewController {

    @IBOutlet weak var homePageCollectionView: UICollectionView!
    
    private let cellNibNameKey = "HomePageCell"
    private let headerCellKey = "homePageHeaderCell"
    
    private let sectionTitles : [String] = ["All Time Best"]
    // Sections titles
    
    var gameResult : [GameDataModelResult] = []
    private var totalCountOfDatas : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        fetchData()
    }

    fileprivate var pageNumber = 1
    fileprivate var isPagination = false
    
    func fetchData() {
        Responses.shared.fetchAllTimeBest(pageNumber:pageNumber) { result in
            switch result {
            case .success(let successData):
                DispatchQueue.main.async {
                    self.gameResult = successData.results
                    self.totalCountOfDatas = successData.count
                    self.homePageCollectionView.reloadData()
                }
            case .failure(_):
                break
            }
        }
        
    }
    
}

extension HomePageController {
    private func setupCollectionView() {
        homePageCollectionView?.register(.init(nibName: cellNibNameKey, bundle: nil), forCellWithReuseIdentifier: cellNibNameKey)
        homePageCollectionView?.dataSource = self
        homePageCollectionView?.delegate = self
        homePageCollectionView.collectionViewLayout = createCollectionViewLayout()
    }
}

extension HomePageController : UICollectionViewDelegate {
    // TO:DO did select to detailVC

}

extension HomePageController : UICollectionViewDataSource {

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionTitles.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameResult.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellNibNameKey, for: indexPath) as! HomePageCell
        cell.setHomePageCell(with: gameResult[indexPath.item])
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellKey, for: indexPath) as! HomePageCollectionViewHeaderResuableCell
            header.setup(sectionTitles[indexPath.section])
            return header
        default : return UICollectionViewCell()
        }
    }
}

extension HomePageController: UICollectionViewDelegateFlowLayout {
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
      
        // item
          let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.20),
                heightDimension: .fractionalHeight(1.30)))
          item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
                
        // group
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/1.10),
            heightDimension: .fractionalHeight(1/3)
          ),
          subitem: item,
          count: 1
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
                
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                
        // return
        return section
    }
  }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}


