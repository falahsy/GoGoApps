//
//  ProfileViewController.swift
//  cycle
//
//  Created by Ferry Irawan on 22/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profPicImage: UIImageView!{
        didSet{
            profPicImage.layer.cornerRadius = profPicImage.frame.size.width/2
            profPicImage.clipsToBounds = true
            //sad
            
            
        }
    }
    @IBOutlet weak var profileImgBkgView: UIView!{
        didSet{
        profileImgBkgView.backgroundColor = GoGoColor.MAIN
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
