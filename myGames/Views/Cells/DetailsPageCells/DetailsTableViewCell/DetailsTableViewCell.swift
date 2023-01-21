//
//  DetailsTableViewCell.swift
//  myGames
//
//  Created by YILDIRIM on 19.01.2023.
//

import UIKit
import Kingfisher

class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailsCellCollectionView: UICollectionView!
    
    @IBOutlet weak var pageViewControl: UIPageControl!
    @IBOutlet weak var detailCellView: UIView!
    
    private var detailsImageCollectionCellKey = "ImageCollectionCell"
    
    var screenShotArr : [ScreenshotResult] = []
    
    //Slider variables
    var timer = Timer()
    var counter = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
            setupCollectionView()
            initPageControl()
    }
    
    private func initPageControl() {
        pageViewControl.currentPage = 0
        
        DispatchQueue.main.async {
              self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
           }
    }
    
    @objc func changeImage() {
             
         if counter < screenShotArr.count {
              let index = IndexPath.init(item: counter, section: 0)
              self.detailsCellCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
             pageViewControl.currentPage = counter
              counter += 1
         } else {
              counter = 0
              let index = IndexPath.init(item: counter, section: 0)
              self.detailsCellCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
             pageViewControl.currentPage = counter
               counter = 1
           }
      }
    
    private func setupCollectionView() {
        detailsCellCollectionView.register(.init(nibName: detailsImageCollectionCellKey, bundle: nil), forCellWithReuseIdentifier: detailsImageCollectionCellKey)
        detailsCellCollectionView.dataSource = self
        detailsCellCollectionView.delegate = self
    }
}

extension DetailsTableViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageViewControl.numberOfPages = screenShotArr.count
        return screenShotArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailsCellCollectionView.dequeueReusableCell(withReuseIdentifier: detailsImageCollectionCellKey, for: indexPath) as! ImageCollectionCell
        
        let screenshot = screenShotArr[indexPath.item].image
        
        cell.detailsImageView.kf.setImage(with: URL(string: screenshot))
        cell.detailsImageView.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width - 8, height: frame.height)
    }
}

