//
//  MapCell.swift
//  cycle
//
//  Created by Azmi Muhammad on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UITableViewCell {

    static let identifier: String = "MapCell"
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
