//
//  CyclistCollectionCell.swift
//  cycle
//
//  Created by boy setiawan on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class CyclistCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageViewFrame: UIView! {
        didSet {
            imageViewFrame.setupRadius(type: .rounded, isMaskToBounds: true)
            imageViewFrame.layer.borderWidth = 1
            imageViewFrame.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var title: UILabel!
    
    var cyclistInfo: CyclistInfo? {
        didSet {
            guard let cyclistInfo = cyclistInfo else {return}
            setupView(cyclistInfo)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setupView(_ cyclist: CyclistInfo) {
        title.text = cyclist.title
        distance.text = cyclist.distance
    }
}
