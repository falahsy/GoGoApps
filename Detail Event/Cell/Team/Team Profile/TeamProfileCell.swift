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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageFrame: UIView! {
        didSet {
            imageFrame.setupRadius(type: .rounded, isMaskToBounds: true)
            imageFrame.layer.borderWidth = 1
            imageFrame.layer.borderColor = UIColor.black.cgColor
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
    
    var member: User? {
        didSet {
            guard let member = member else { return }
            nameLabel.text = member.fullName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
