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
    
    var event: UpcomingEventInfo? {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: "#F9F9F9")
    }
    
    private func setupView() {
        guard let event = event else {return setupEmptyView()}
        eventLabel.text = event.activityID
        dateLabel.text = "At \(Pretiffy.formatDate(date: event.date))"
        membersLabel.text = "\(event.friends) Friends"
        destinationLabel.text = "Destination \(event.destination)"
        infoLabel.text = "Distance \(Pretiffy.getDistance(distance: event.distance)) ETA \(Pretiffy.getETA(seconds: event.eta))"
    }
    
    private func setupEmptyView() {
        dateLabel.text = "No Event Date"
        eventLabel.text = "No Event"
        membersLabel.text = "0 Friends"
        destinationLabel.text = "No Destination"
        infoLabel.text = "Distance : 0 km ETA : 0:0"
    }
  
}
