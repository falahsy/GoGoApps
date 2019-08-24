//
//  EventCreatedVC.swift
//  cycle
//
//  Created by boy setiawan on 23/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import Foundation
import UIKit

class EventCreatedVC: UIViewController{
    
    @IBOutlet weak var doneButton: UIButton!{
        didSet{
            doneButton.layer.cornerRadius = doneButton.frame.size.height/2
            doneButton.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var codeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        self.codeLabel.text = defaults.string(forKey: "activity")
    }
   
    
    @IBAction func done(_ sender: UIButton) {
        let homeVC = HomeVC()
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}
