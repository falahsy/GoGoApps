//
//  TeamProfileCell.swift
//  cycle
//
//  Created by Azmi Muhammad on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class TeamProfileCell: UICollectionViewCell {

    static let identifier: String = "TeamProfileCell"
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.setupRadius(type: .rounded, isMaskToBounds: true)
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var view: UIView! {
        didSet {
            view.setupRadius(type: .custom(8.0))
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = "Brocolli"
        }   
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
