//
//  DetailsTableViewCell.swift
//  myGames
//
//  Created by YILDIRIM on 19.01.2023.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var detailsCellCollectionView: UICollectionView!
    
    private var detailsImageCollectionCellKey = "ImageCollectionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        detailsCellCollectionView.register(.init(nibName: detailsImageCollectionCellKey, bundle: nil), forCellWithReuseIdentifier: detailsImageCollectionCellKey)
        detailsCellCollectionView.dataSource = self
        detailsCellCollectionView.delegate = self
    }
}

extension DetailsTableViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = detailsCellCollectionView.dequeueReusableCell(withReuseIdentifier: detailsImageCollectionCellKey, for: indexPath) as! ImageCollectionCell
            cell.detailsImageView.backgroundColor = .red
        cell.detailsImageView.layer.cornerRadius = 10
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width - 16, height: frame.height - 16)
    }
}

