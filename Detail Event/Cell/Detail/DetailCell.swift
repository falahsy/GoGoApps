//
//  DetailCell.swift
//  cycle
//
//  Created by Azmi Muhammad on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    static let identifier: String = "DetailCell"
    
    @IBOutlet weak var dayAndDateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var durationView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupView() {
        dateView.setupRadius(type: .custom(8.0))
        distanceView.setupRadius(type: .custom(8.0))
        durationView.setupRadius(type: .custom(8.0))
    }
    
}
