//
//  HomeViewController.swift
//  GogoApps
//
//  Created by Ferry Irawan on 16/08/19.
//  Copyright © 2019 MC3. All rights reserved.
//

import UIKit
import MapKit
import Hex

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    func configTableView(){
        tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "homeCell")
        tableView.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellReuseIdentifier: "homeHeaderCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "gogo"
    }
}
extension HomeVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 376
        } else{
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "homeHeaderCell", for: indexPath)) as! HomeHeaderCell
            return cell
        }else{
            let cell = (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)) as! HomeCell
            return cell
        }
    }
    
    
}
