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
        let code = Preference.getString(forKey: .kUserActivity)
        codeLabel.text = code
    }
   
    
    @IBAction func done(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
