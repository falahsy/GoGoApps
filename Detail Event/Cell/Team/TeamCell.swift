//
//  TeamCell.swift
//  cycle
//
//  Created by Azmi Muhammad on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {

    static let identifier: String = "TeamCell"
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: TeamProfileCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamProfileCell.identifier)
    }
    
}

extension TeamCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamProfileCell.identifier, for: indexPath) as? TeamProfileCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120.0, height: 140.0)
    }
}
