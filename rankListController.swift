//
//  rankListController.swift
//  gogoApps Extension
//
//  Created by Andika Leonardo on 03/09/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
import WatchKit

class rankListController: WKInterfaceController {
    @IBOutlet weak var RankTable: WKInterfaceTable!
    
    var shared: WSManager = WSManager.shared
    var data: [CyclistInfo] = [] {
        didSet {
            updateTable()
        }
    }
    
    override func willActivate() {
        super.willActivate()
        
        shared.startSession()
        shared.watchOSDelegate = self
    }
    
    
    private func updateTable() {
        RankTable.setNumberOfRows(data.count, withRowType: "RankRow")
        for (i, e) in data.enumerated() {
            guard let row = RankTable.rowController(at: i) as? RankRow else {return}
            row.nameLabel.setText(e.title)
            row.distanceLabel.setText(e.distance)
            row.rankLabel.setText(e.subtitle)
        }
    }
}

extension rankListController: WatchOSDelegate {
    func messageReceived(tuple: MessageReceived) {
        guard var data = tuple.message[RequestType.start.rawValue] as? [CyclistInfo] else {return}
        
        DispatchQueue.main.async {
            data.append(CyclistInfo(title: "Brew", subtitle: "1", distance: "14 KM"))
            data.append(CyclistInfo(title: "Cokro", subtitle: "2", distance: "10 KM"))
            data.append(CyclistInfo(title: "You", subtitle: "3", distance: "0 KM"))
            data.append(CyclistInfo(title: "Riu", subtitle: "4", distance: "4 KM"))
            data.append(CyclistInfo(title: "Burhan", subtitle: "5", distance: "6 KM"))
            self.data = data
        }
    }
}
