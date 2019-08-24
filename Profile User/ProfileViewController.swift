//
//  ProfileViewController.swift
//  cycle
//
//  Created by Ferry Irawan on 22/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let titles: [String] = ["DOB", "Address", "Community"]
    var profile: [String] = ["Dec 1996", "BSD, Tangerang Selatan", "Gopur"]
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var profPicImage: UIImageView!{
        didSet{
            profPicImage.layer.cornerRadius = profPicImage.frame.size.width/2
            profPicImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var profileImgBkgView: UIView!{
        didSet{
            profileImgBkgView.backgroundColor = GoGoColor.MAIN
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController(title: "Profile", prefLargeTitle: true, isHidingBackButton: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setupLargeTitle(prefLargeTitle: false)
    }
    
    @IBAction func onLogoutTapped(_ sender: UIButton) {
        Preference.set(value: false, forKey: .kUserLogin)
        let vc = LoginVC()
        vc.isLogin = true
        navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = titles[indexPath.row]
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        label.text = profile[indexPath.row]
        label.sizeToFit()
        label.numberOfLines = 0
        cell.accessoryView = label
        
        return cell
    }
    
    
}
