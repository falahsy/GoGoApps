//
//  HomeHeaderCell.swift
//  GogoApps
//
//  Created by Ferry Irawan on 19/08/19.
//  Copyright © 2019 MC3. All rights reserved.
//

import UIKit

class HomeHeaderCell: UITableViewCell {
    
    @IBOutlet weak var createView: UIView!{
        didSet{
            createView.layer.cornerRadius = 7
            createView.clipsToBounds = true
        }
    }
    @IBOutlet weak var joinView: UIView!{
        didSet{
            joinView.layer.cornerRadius = 5
            joinView.clipsToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: "#F9F9F9")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
