//
//  HomeHeaderCell.swift
//  GogoApps
//
//  Created by Ferry Irawan on 19/08/19.
//  Copyright © 2019 MC3. All rights reserved.
//

import UIKit

protocol homeCellDelegate:class{
    func toProfile()
}
class HomeHeaderCell: UITableViewCell {
    
    var delegate: homeCellDelegate?
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: "#F9F9F9")
        profileBtn.addTarget(self, action: #selector(toProfile), for: .touchUpInside)
    }
    @IBOutlet weak var profileBtn: UIButton!{
        didSet{
            profileBtn.layer.cornerRadius = profileBtn.frame.size.width/2
            profileBtn.clipsToBounds = true
        }
    }
    @objc func toProfile(){
        self.delegate?.toProfile()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
