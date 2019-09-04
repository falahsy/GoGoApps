//
//  EmergencyController.swift
//  gogoApps Extension
//
//  Created by Andika Leonardo on 03/09/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import WatchKit
import WatchConnectivity

class EmergencyController: WKInterfaceController {
    
    @IBOutlet weak var EmergencyBtn: WKInterfaceButton!
    
    var manager = WSManager.shared
    
    override func willActivate() {
        super.willActivate()
        
        manager.startSession()
    }
    
    @IBAction func onSosTapped() {
        let data = ["request" : RequestType.sos.rawValue as AnyObject]
        manager.session?.sendMessage([RequestType.sos.rawValue : "Help"], replyHandler: nil, errorHandler: { (err) in
            print(err)
        })
    }
}
