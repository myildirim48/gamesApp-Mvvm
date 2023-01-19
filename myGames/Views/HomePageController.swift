//
//  ViewController.swift
//  myGames
//
//  Created by YILDIRIM on 12.01.2023.
//

import UIKit


class HomePageController: UIViewController {
    
    @IBOutlet weak var homePageViewAiv: UIActivityIndicatorView!
    @IBOutlet weak var homePageCollectionView: UICollectionView!
    
    private let cellNibNameKey = "HomePageCell"
    private let headerCellKey = "homePageHeaderCell"
    
    private let sectionTitles : [String] = ["All Time Best","Best Of 2022","Released in last week","Metascore +90"]
    // Sections titles
    
    var gameResultGroup = [GameDataModel]()
    
    var gameResultFirst : GameDataModel?
    var gameResultSecond : GameDataModel?
    var gameResultThird : GameDataModel?
    var gameResultFourth : GameDataModel?
    
    //Pagination Variables
    fileprivate var totalCountOfDatas = 0
    fileprivate var totalPages = 0
    fileprivate var pageNumOfBestOfAll = 1
    fileprivate var pageNumOfBestOf2022 = 1
    fileprivate var pageNumOfLastWeekReleased = 1
    fileprivate var pageNumOfMetacritic = 1
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
    
    func fetchAllTimeBestData(page: Int) {
        self.dispatchGroup.enter()
        Responses.shared.fetchAllTimeBest(pageNumber:page) { result in
            
            switch result {
            case .success(let successData):
                if self.gameResultGroup.count > 2 { //For pagination
                    
                    DispatchQueue.main.async {
                        self.gameResultGroup[0].results += successData.results
                        self.homePageCollectionView.reloadData()
                    }
                    
                }else {
                    
                    print("1")//For bugfix
                    
                    self.queue.async(group:self.dispatchGroup){
                        self.gameResultFirst = successData
                    }
                    self.dispatchGroup.leave()
                }
            case .failure(_):
                break
            }
        }
    }
    
    func fetchBestOf2022(page: Int) {
        self.dispatchGroup.enter()
        Responses.shared.fetchBestof2022(pageNumber: page) { resultBest in
            
            switch resultBest {
            case .success(let success):
                //For pagination --->
                if self.gameResultGroup.count > 2 {
                    DispatchQueue.main.async {
                        self.gameResultGroup[1].results += success.results
                        self.homePageCollectionView.reloadData()
                    }
                }else{
                    print("2")
                    self.queue.async(group:self.dispatchGroup) {
                        self.gameResultSecond = success
                    }
                    self.dispatchGroup.leave()
                }
            case .failure(_):
                break
            }
        }
    }
    
    
    
    func fetchLast30DaysReleased(page: Int){
        
        //---> Takes today's date and minus 30 days from today
        let toDate = Date()
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -30, to: toDate) else { return }
        
        let dateTodayString = DataTransform.shared.dateToString(toDate)
        let dateFromString = DataTransform.shared.dateToString(fromDate)
        //---> Takes today's date and minus 30 days from today
        
        self.dispatchGroup.enter()
        Responses.shared.fetchInLast30Days(pageNumber: page, dateFrom: dateFromString, dateTo: dateTodayString) { lastResult in
            
            switch lastResult {
            case .success(let successLast):
                if self.gameResultGroup.count > 2 {
                    DispatchQueue.main.async {
                        self.gameResultGroup[2].results += successLast.results
                        self.homePageCollectionView.reloadData()
                    }
                }else{
                    print("3")
                    self.queue.async(group:self.dispatchGroup) {
                        self.gameResultThird = successLast
                    }
                    self.dispatchGroup.leave()
                }
            case .failure(let err):
                print("Error while fetching data @30Days Released",err.localizedDescription)
            }
        }
        
    }
    
    func fetchMetacritic(page:Int) {
        self.dispatchGroup.enter()
        Responses.shared.feetchMetacritic(pageNumber: page) { resultMeta in
            switch resultMeta {
            case.success(let successData):
                if self.gameResultGroup.count > 2 {
                    DispatchQueue.main.async {
                        self.gameResultGroup[3].results += successData.results
                        self.homePageCollectionView.reloadData()
                    }
                }else {
                    print("3")
                    self.queue.async(group: self.dispatchGroup) {
                        self.gameResultFourth = successData
                    }
                    self.dispatchGroup.leave()
                }
            case .failure(_):
                break
            }
        }
        
    }
    
    func fetchAllDatasWithGroup() {
        fetchAllTimeBestData(page: pageNumOfBestOfAll)
        fetchLast30DaysReleased(page: pageNumOfLastWeekReleased)
        fetchBestOf2022(page: pageNumOfBestOf2022)
        fetchMetacritic(page: pageNumOfMetacritic)
        
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
            if let data4 = gameResultFourth {
                gameResultGroup.append(data4)
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
        
        //I did this control here for performance. indexpath 18+ checking for pagination. from api in every response total 20 result is coming
        
        if indexPath.item >= 17 {
            switch indexPath.section {
            case 0 :
                if indexPath.item == gameDataResult.count - 1   && !isPagination && pageNumOfBestOfAll < totalPages {
                    
                    cell.homepageCellView.isHidden = true
                    cell.homepageCellAiv.startAnimating()
                    
                    pageNumOfBestOfAll += 1
                    isPagination = true
                    
                    timer?.invalidate()
                    timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        
                        self.fetchAllTimeBestData(page: self.pageNumOfBestOfAll)
                        
                        cell.homepageCellView.isHidden = false
                        cell.homepageCellAiv.stopAnimating()
                        
                        self.isPagination = false
                    })
                }
                return cell
            case 1:
                if indexPath.item == gameDataResult.count - 1   && !isPagination && pageNumOfBestOf2022 < totalPages {
                
                    cell.homepageCellView.isHidden = true
                    cell.homepageCellAiv.startAnimating()
                    
                    pageNumOfBestOf2022 += 1
                    isPagination = true
                    
                    timer?.invalidate()
                    timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        
                        self.fetchBestOf2022(page: self.pageNumOfBestOf2022)
                        
                        cell.homepageCellView.isHidden = false
                        cell.homepageCellAiv.stopAnimating()
                        
                        self.isPagination = false
                    })
                    return cell
                }
            case 2:
                print(indexPath.item)
                if indexPath.item == gameDataResult.count - 1  && !isPagination && pageNumOfLastWeekReleased <= totalPages {
                    
                    cell.homepageCellView.isHidden = true
                    cell.homepageCellAiv.startAnimating()
                    
                    pageNumOfLastWeekReleased += 1
                    isPagination = true
                    
                    timer?.invalidate()
                    timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        
                        self.fetchLast30DaysReleased(page: self.pageNumOfLastWeekReleased)
                        
                        cell.homepageCellView.isHidden = false
                        cell.homepageCellAiv.stopAnimating()
                        
                        self.isPagination = false
                    })
                    return cell
                }
            case 3:
                if indexPath.item == gameDataResult.count - 1  && !isPagination && pageNumOfMetacritic <= totalPages {
                    print(indexPath.item)
                    
                    cell.homepageCellView.isHidden = true
                    cell.homepageCellAiv.startAnimating()
                    
                    pageNumOfMetacritic += 1
                    isPagination = true
                
                    timer?.invalidate()
                    timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        
                        self.fetchMetacritic(page: self.pageNumOfMetacritic)
                        
                        cell.homepageCellView.isHidden = false
                        cell.homepageCellAiv.stopAnimating()
                        self.isPagination = false
                    })
                    return cell
                }
            default:
                return cell
            }
        }
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


