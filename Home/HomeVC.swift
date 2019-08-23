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
    
    var todayContent = 2
    var upcomingContent = 3
    @IBOutlet weak var tableView: UITableView!
    func configTableView(){
        tableView.backgroundColor = UIColor(hex: "#F9F9F9")
        tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "homeCell")
        tableView.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellReuseIdentifier: "homeHeaderCell")
        tableView.register(UINib(nibName: "HomeDateCell", bundle: nil), forCellReuseIdentifier: "homeDateCell")
        tableView.register(UINib(nibName: "HomeNoEventCell", bundle: nil), forCellReuseIdentifier: "homeNoEventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLargeTitle(title: "GoGo", prefLargeTitle: false, isHidingBackButton: true)
    }
}
extension HomeVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todayContent != 0 && upcomingContent != 0{
            return 3 + todayContent + upcomingContent
        } else if todayContent == 0 && upcomingContent != 0{
            return 2 + upcomingContent
        } else if todayContent != 0 && upcomingContent == 0{
            return 2 + todayContent
        } else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if todayContent != 0 && upcomingContent != 0{
            if indexPath.row == 0 {
                return 324
            }else if indexPath.row == 1 { //today date
                return 44
            }else if indexPath.row > 1 && indexPath.row < todayContent + 2{ //today content
                return 110
            }else if indexPath.row == todayContent + 2{ //upcoming label
                return 44
            }else{ //upcoming content
                return 110
            }
        } else if todayContent == 0 && upcomingContent != 0{
            if indexPath.row == 0 {
                return 324
            }else if indexPath.row == 1 { //upcoming label
                return 44
            }else{ //upcoming content
                return 110
            }
        } else if todayContent != 0 && upcomingContent == 0{
            if indexPath.row == 0 {
                return 324
            }else if indexPath.row == 1 { //today date
                return 44
            }else{ //today content
                return 110
            }
        } else{
            if indexPath.row == 0 {
                return 324
            }else {
                return 408
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if todayContent != 0 && upcomingContent != 0{
            if indexPath.row == 0 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeHeaderCell", for: indexPath)) as! HomeHeaderCell
                cell.delegate = self
                return cell
            }else if indexPath.row == 1 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeDateCell", for: indexPath)) as! HomeDateCell
                cell.dateLbl.text = "Today, \(getCurrDate())"
                return cell
            }else if indexPath.row > 1 && indexPath.row < todayContent + 2{
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)) as! HomeCell
                return cell
            }else if indexPath.row == todayContent + 2{
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeDateCell", for: indexPath)) as! HomeDateCell
                cell.dateLbl.text = "Upcoming Events"
                return cell
            }else{
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)) as! HomeCell
                return cell
            }
        } else if todayContent == 0 && upcomingContent != 0{
            if indexPath.row == 0 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeHeaderCell", for: indexPath)) as! HomeHeaderCell
                return cell
            }else if indexPath.row == 1 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeDateCell", for: indexPath)) as! HomeDateCell
                cell.dateLbl.text = "Upcoming Events"
                return cell
            }else {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)) as! HomeCell
                return cell
            }
        } else if todayContent != 0 && upcomingContent == 0{
            if indexPath.row == 0 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeHeaderCell", for: indexPath)) as! HomeHeaderCell
                return cell
            }else if indexPath.row == 1 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeDateCell", for: indexPath)) as! HomeDateCell
                cell.dateLbl.text = "Today, \(getCurrDate())"
                return cell
            }else {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)) as! HomeCell
                return cell
            }
        } else{
            if indexPath.row == 0 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeHeaderCell", for: indexPath)) as! HomeHeaderCell
                return cell
            }else {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeNoEventCell", for: indexPath)) as! HomeNoEventCell
                return cell
            }
        }
        
    }
}
extension HomeVC{
    func getCurrDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let result = formatter.string(from: date)
        return result
    }
}
extension HomeVC : homeCellDelegate{
    func toProfile() {
        let vc = ProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
