//
//  FriendsCell.swift
//  cycle
//
//  Created by Azmi Muhammad on 21/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class FriendsCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    var model: Cyclist? {
        didSet {
            guard let model = self.model else { return }
            self.label.text = model.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
