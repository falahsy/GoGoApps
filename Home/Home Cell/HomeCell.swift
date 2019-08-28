//
//  HomeCell.swift
//  GogoApps
//
//  Created by Ferry Irawan on 19/08/19.
//  Copyright © 2019 MC3. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    
    
   
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var cellView: UIView!{
        didSet{
            cellView.layer.cornerRadius = 7
            cellView.clipsToBounds = true
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
