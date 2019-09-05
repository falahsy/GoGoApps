//
//  HomeCell.swift
//  GogoApps
//
//  Created by Ferry Irawan on 19/08/19.
//  Copyright © 2019 MC3. All rights reserved.
//

import UIKit

protocol homeDelegate : class{
    func toActDetail(actID : String, row : Int, isToday : Bool)
}
class HomeCell: UITableViewCell {
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    weak var delegate : homeDelegate?
    @IBOutlet weak var cellView: UIView!{
        didSet{
            cellView.layer.cornerRadius = 7
            cellView.clipsToBounds = true
        }
    }
    @IBOutlet weak var toDetailBtn: UIButton!
    var event: UpcomingEventInfo? {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: "#F9F9F9")
        toDetailBtn.addTarget(self, action: #selector(toDetail), for: .touchUpInside)
    }
    
    private func setupView() {
        guard let event = event else {return}
        eventLabel.text = event.activityID
        dateLabel.text = "At \(Pretiffy.formatDate(date: event.date))"
        membersLabel.text = "\(event.friends) Friends"
        destinationLabel.text = "\(event.destination)"
        infoLabel.text = "Distance \(Pretiffy.getDistance(distance: event.distance)) ETA \(Pretiffy.getETA(seconds: event.eta))"
    }
    
    @objc func toDetail(){
        guard let event = event else {return }
        self.delegate?.toActDetail(actID: event.activityID, row : event.row, isToday: event.isToday)
    }
}
