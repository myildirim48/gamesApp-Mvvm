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
    
    private let viewModel = HomePageViewModel()
    
    private let cellNibNameKey = "HomePageCell"
    private let headerCellKey = "homePageHeaderCell"
    private let detailsPageKey = ""
    private let sectionTitles : [String] = ["All Time Best","Best Of 2022","All Time Best Multiplayer","Metascore +90"]
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
        fetchAllData()
        setupCollectionView()
        navigationItem.title = gamesConst
    }
    //MARK: - data fetch functions

    let dispatchGroup = DispatchGroup()
    let queue = DispatchQueue.global(qos: .default)
    
    func fetchAllTimeBestData(page: Int) {
        print(1)
        self.dispatchGroup.enter()
        viewModel.fetchAllTimeBest(with: page)
        viewModel.allTimeBestData = {  data in
            if self.gameResultGroup.count > 3 {
                self.gameResultGroup[0].results += data.results
                self.homePageCollectionView.reloadData()
            }else{
                self.queue.async(group:self.dispatchGroup){
                    self.gameResultFirst = data
                                }
            self.dispatchGroup.leave()
            }
        }
    }

    func fetchBestOf2022(page: Int) {
        print(2)
        self.dispatchGroup.enter()
        viewModel.fetchBestOf2022(with: page)
        viewModel.bestOf2022 = { best in
            if self.gameResultGroup.count > 3 {
                self.gameResultGroup[1].results += best.results
                self.homePageCollectionView.reloadData()
            }else{
                self.queue.async(group:self.dispatchGroup){
                    self.gameResultSecond = best
                                }
            self.dispatchGroup.leave()
            }
            
        }
    }
    
    func fetcBestOfMultiplayer(page: Int){
        print(3)
        self.dispatchGroup.enter()
        viewModel.fetchBestOfMultiPlayer(with: page)
        viewModel.bestOfMulti = { multi in
            if self.gameResultGroup.count > 3 {
                self.gameResultGroup[2].results += multi.results
                self.homePageCollectionView.reloadData()
            }else{
                self.queue.async(group:self.dispatchGroup){
                    self.gameResultThird = multi
                                }
            self.dispatchGroup.leave()
            }
        }
    }
    
    func fetchMetacritic(page:Int) {
        print(4)
        self.dispatchGroup.enter()
        viewModel.fetchMetacriticData(with: page)
        viewModel.metacriticData = { meta in
            if self.gameResultGroup.count > 3 {
                self.gameResultGroup[3].results += meta.results
                self.homePageCollectionView.reloadData()
            }else{
                self.queue.async(group:self.dispatchGroup){
                    self.gameResultFourth = meta
                                }
            self.dispatchGroup.leave()

            }
        }
    }
    
    private func showAlert() {
        viewModel.showErrorView = { [weak self] err in
            self?.makeAlert(title: "Error", message: err)
        }
    }
    private func makeAlert(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        self.present(alertController, animated: true)
    }

    func fetchAllData(){
        fetchAllTimeBestData(page: pageNumOfBestOfAll)
        fetchBestOf2022(page: pageNumOfBestOf2022)
        fetcBestOfMultiplayer(page: pageNumOfLastWeekReleased)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let gameDetailPage = mainStoryBoard.instantiateViewController(withIdentifier: "gameDetailPage") as? DetailsPageController else {
            return
        }
        guard let gameId = gameResultGroup[indexPath.section].results[indexPath.item].id else { return }
        
        gameDetailPage.gameIdDetails = gameId
        navigationController?.pushViewController(gameDetailPage, animated: true)
    }
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
            totalPages = gameResultGroup[indexPath.section].count  / 20
            
        }else {
            totalPages = (totalCountOfDatas / 20) + 1
        }
        
        
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
                        
                        self.fetcBestOfMultiplayer(page: self.pageNumOfLastWeekReleased)
                        
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
                    heightDimension: .fractionalHeight(1.50)))
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 75, trailing: 0)
            section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
            
            // return
            return section
        }
    }
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}


