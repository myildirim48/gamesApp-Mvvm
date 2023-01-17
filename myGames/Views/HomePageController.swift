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

    @IBOutlet weak var homePageViewAiv: UIActivityIndicatorView!
    @IBOutlet weak var homePageCollectionView: UICollectionView!
    
    private let cellNibNameKey = "HomePageCell"
    private let headerCellKey = "homePageHeaderCell"
    
    private let sectionTitles : [String] = ["All Time Best","Best Of 2022","Released in last week"]
    // Sections titles
    
    var gameResultGroup = [GameDataModel]()

    var gameResultFirst : GameDataModel?
    var gameResultSecond : GameDataModel?
    var gameResultThird : GameDataModel?
    
    //Pagination Variables
    fileprivate var totalCountOfDatas = 0
    fileprivate var totalPages = 0
    fileprivate var pageNumber = 1
    fileprivate var isPagination = false
    
    fileprivate var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllDatasWithGroup()
        
        setupCollectionView()
        
    }
    
    //MARK: - data fetch functions
    
    let dispatchGroup = DispatchGroup()
    let queue = DispatchQueue.global(qos: .default)
    
    func fetchAllTimeBestData(page: Int = 1) {
        self.dispatchGroup.enter()
            Responses.shared.fetchAllTimeBest(pageNumber:page) { result in
       
            switch result {
            case .success(let successData):
                    if self.gameResultGroup.count > 2 { //For pagination
                        self.gameResultGroup[0].results += successData.results
                    }else {
                        //1
                        print("1")
                        self.queue.async(group:self.dispatchGroup){
//                            self.gameResultGroup.append(successData)
                            self.gameResultFirst = successData
                        }
                        
                        
                        self.dispatchGroup.leave()
//
//                        DispatchQueue.main.async {
//                            self.homePageCollectionView.reloadData()
//                        }
                    }
            case .failure(_):
                break
            }
        }
    }
    
    func fetchBestOf2022(page: Int = 1) {
        self.dispatchGroup.enter()
        Responses.shared.fetchBestof2022(pageNumber: page) { resultBest in
           
            switch resultBest {
            case .success(let success):
                    if self.gameResultGroup.count > 2 { //For pagination
                        self.gameResultGroup[1].results += success.results
                    }else{
                        print("2")
                        self.queue.async(group:self.dispatchGroup) {
//                            self.gameResultGroup.append(success)
                            self.gameResultSecond = success
                        }
//                        DispatchQueue.main.async {
//                            self.homePageCollectionView.reloadData()
//                        }
                        self.dispatchGroup.leave()
                    }
            case .failure(_):
                break
            }
        }
    }
    
  
    
    func fetchLast30DaysReleased(page: Int = 1){
        
        let toDate = Date()
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -7, to: toDate) else { return }
        
        let dateTodayString = DataTransform.shared.dateToString(toDate)
        let dateFromString = DataTransform.shared.dateToString(fromDate)
        
        self.dispatchGroup.enter()
        Responses.shared.fetchInLast30Days(pageNumber: page, dateFrom: dateFromString, dateTo: dateTodayString) { lastResult in
            
            switch lastResult {
            case .success(let successLast):
                    if self.gameResultGroup.count > 2 {
                        self.gameResultGroup[2].results += successLast.results
                    }else{
                        print("3")
                        self.queue.async(group:self.dispatchGroup) {
//                            self.gameResultGroup.append(successLast)
                            self.gameResultThird = successLast
                        }
                        
                        self.dispatchGroup.leave()
//                        DispatchQueue.main.async {
//                            self.homePageCollectionView.reloadData()
//                        }
                    }
            case .failure(let err):
                print("Error while fetching data @30Days Released",err.localizedDescription)
            }
        }
        
    }
    
    func fetchAllDatasWithGroup() {
        fetchAllTimeBestData()
        fetchLast30DaysReleased()
        fetchBestOf2022()
        
        dispatchGroup.notify(queue: .main) { [self] in
            if let data1 = gameResultFirst{
                gameResultGroup.append(data1)
            }
            if let data2 = gameResultSecond{
                gameResultGroup.append(data2)
            }
            if let data3 = gameResultThird{
                gameResultGroup.append(data3)
            }
      
            self.homePageCollectionView.reloadData()
            self.homePageViewAiv.stopAnimating()
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


//MARK: - CollectionView DataSource and Pagination
extension HomePageController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameResultGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameResultGroup[section].results.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let gameDataResult = gameResultGroup[indexPath.section].results
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellNibNameKey, for: indexPath) as! HomePageCell
        cell.setHomePageCell(with: gameDataResult[indexPath.item])
        cell.layer.cornerRadius = 10
        
        if totalCountOfDatas % 20 == 0 {
            totalPages = gameResultGroup[indexPath.section].count / 20
            
        }else {
            totalPages = (totalCountOfDatas / 20) + 1
        }
        
        if indexPath.item >= 16 {
        switch indexPath.section {
        case 0 :
            if indexPath.item == gameDataResult.count - 1   && !isPagination && pageNumber < totalPages {
                
                pageNumber += 1
                isPagination = true
                
                cell.homepageCellView.isHidden = true
                cell.homepageCellAiv.startAnimating()
                
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                    
                    self.fetchAllTimeBestData(page: self.pageNumber)
                    
                    cell.homepageCellView.isHidden = false
                    
                    collectionView.reloadData()
                    cell.homepageCellAiv.stopAnimating()
                    
                    self.isPagination = false
                })
            }
            return cell
        case 1:
            if indexPath.item == gameDataResult.count - 1   && !isPagination && pageNumber < totalPages {
                
                
                pageNumber += 1
                isPagination = true
                
                cell.homepageCellView.isHidden = true
                cell.homepageCellAiv.startAnimating()
                
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                    
                    self.fetchBestOf2022(page: self.pageNumber)
                    cell.homepageCellView.isHidden = false
                    
                    self.homePageCollectionView.reloadData()
                    cell.homepageCellAiv.stopAnimating()
                    self.isPagination = false
                })
                return cell
            }
        case 2:
            print(indexPath.item)
            if indexPath.item == gameDataResult.count - 1  && !isPagination && pageNumber <= totalPages {
                print(indexPath.item)
                pageNumber += 1
                isPagination = true
                
                cell.homepageCellView.isHidden = true
                cell.homepageCellAiv.startAnimating()
                
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                    
                    self.fetchLast30DaysReleased(page: self.pageNumber)
                    cell.homepageCellView.isHidden = false
                    cell.homepageCellAiv.stopAnimating()
                    self.isPagination = false
                })
                return cell
            }
        default:
            break
        }
        }
        //Total pages counting
   
        return cell
        
    }
    
    //Header ->
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

//Compositional layout
extension HomePageController: UICollectionViewDelegateFlowLayout {
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
      
        // item
          let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.20),
                heightDimension: .fractionalHeight(1.30)))
          item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 20, trailing: 5)
                
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 65, trailing: 0)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                
        // return
        return section
    }
  }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}


