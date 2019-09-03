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
    
    var todayContent = 0
    var upcomingContent = 0
    
    var upcomingEvents = [UpcomingEventInfo]()
    var todayEvents = [UpcomingEventInfo]()
    @IBOutlet weak var tableView: UITableView!
    func configTable(){
        tableView.backgroundColor = UIColor(hex: "#F9F9F9")
        tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "homeCell")
        tableView.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellReuseIdentifier: "homeHeaderCell")
        tableView.register(UINib(nibName: "HomeDateCell", bundle: nil), forCellReuseIdentifier: "homeDateCell")
        tableView.register(UINib(nibName: "HomeNoEventCell", bundle: nil), forCellReuseIdentifier: "homeNoEventCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configNavBar()
        configTable()
    }
    
    func configNavBar(){
        self.navigationController?.navigationBar.barTintColor = .white
        setupNavController(title: "Events", prefLargeTitle: true, isHidingBackButton: true)
    }
    
    func fetchData(){
        let userID = Preference.getString(forKey: .kUserEmail)!
        let event = Events()
        upcomingEvents = []
        print(userID)
        event.searchUser(userID: userID) { (events) in
            for upcomingEvent in events{
                let intervalDate = Double(upcomingEvent.date)
                let eventDate = Date(timeIntervalSince1970: intervalDate)
                self.todayEvents.removeAll()
                self.upcomingEvents.removeAll()
                upcomingEvent.searchActivity(activityID: upcomingEvent.activityID, callback: { (friendsInCommon) in
                    let userEvent = UpcomingEventInfo(activityID: upcomingEvent.activityID, date: eventDate, friends: friendsInCommon.count - 1, destination: upcomingEvent.destination, distance: upcomingEvent.distance, eta: upcomingEvent.eta)
                    if self.toDateString(time: eventDate) == self.getCurrDate(){
                        self.todayEvents.append(userEvent)
                    } else {
                        self.upcomingEvents.append(userEvent)
                    }
                    DispatchQueue.main.async {
                        self.todayContent = self.todayEvents.count
                        self.upcomingContent = self.upcomingEvents.count
                        self.tableView.reloadData()
                        
                    }
                })
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
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
                
                if self.todayContent == 0 {
                    cell.dateLabel.text = "No Event Date"
                    cell.eventLabel.text = "No Event"
                    cell.membersLabel.text = "0 Friends"
                    cell.destinationLabel.text = "No Destination"
                    cell.infoLabel.text = "Distance : 0 km ETA : 0:0"
                    return cell

                } else {
                    cell.dateLabel.text = "At \(Pretiffy.formatDate(date: self.todayEvents[indexPath.row-2].date))"
                    cell.eventLabel.text = self.todayEvents[indexPath.row-2].activityID
                    cell.membersLabel.text = "\(self.todayEvents[indexPath.row-2].friends) Friends"
                    cell.destinationLabel.text = "Destination \(self.todayEvents[indexPath.row-2].destination)"
                    cell.infoLabel.text = "Distance \(Pretiffy.getDistance(distance: todayEvents[indexPath.row-2].distance)) ETA \(Pretiffy.getETA(seconds: self.todayEvents[indexPath.row-2].eta))"
                    return cell
                }
            }else if indexPath.row == todayContent + 2{
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeDateCell", for: indexPath)) as! HomeDateCell
                cell.dateLbl.text = "Upcoming Events"
                return cell
            }else{
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)) as! HomeCell
                
//                if self.upcomingEvents.indices.contains(indexPath.row - upcomingContent - 2){
                if self.upcomingContent != 0{
                    cell.dateLabel.text = "At \(Pretiffy.formatDate(date: self.upcomingEvents[indexPath.row - upcomingContent - 2].date))"
                    cell.eventLabel.text = self.upcomingEvents[indexPath.row - upcomingContent - 2].activityID
                    cell.membersLabel.text = "\(self.upcomingEvents[indexPath.row - upcomingContent - 2].friends ) Friends"
                    cell.destinationLabel.text = "Destination \(self.upcomingEvents[indexPath.row - upcomingContent - 2].destination)"
                    cell.infoLabel.text = "Distance \(Pretiffy.getDistance(distance: self.upcomingEvents[indexPath.row - upcomingContent - 2].distance)) ETA \(Pretiffy.getETA(seconds: self.upcomingEvents[indexPath.row - upcomingContent].eta))"
                    return cell
                }else{
                    cell.dateLabel.text = "No Event Date"
                    cell.eventLabel.text = "No Event"
                    cell.membersLabel.text = "0 Friends"
                    cell.destinationLabel.text = "No Destination"
                    cell.infoLabel.text = "Distance : 0 km ETA : 0:0"
                    return cell
                }

                
            }
        } else if todayContent == 0 && upcomingContent != 0{
            if indexPath.row == 0 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeHeaderCell", for: indexPath)) as! HomeHeaderCell
                cell.delegate = self
                return cell
            }else if indexPath.row == 1 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeDateCell", for: indexPath)) as! HomeDateCell
                cell.dateLbl.text = "Upcoming Events"
                return cell
            }else {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)) as! HomeCell
                if self.upcomingContent != 0{
                    cell.dateLabel.text = "At \(Pretiffy.formatDate(date: self.upcomingEvents[indexPath.row - 2].date))"
                    cell.eventLabel.text = self.upcomingEvents[indexPath.row - 2].activityID
                    cell.membersLabel.text = "\(self.upcomingEvents[indexPath.row - 2].friends) Friends"
                    cell.destinationLabel.text = "Destination \(self.upcomingEvents[indexPath.row - 2].destination)"
                    cell.infoLabel.text = "Distance \(Pretiffy.getDistance(distance: self.upcomingEvents[indexPath.row - 2].distance)) ETA \(Pretiffy.getETA(seconds: self.upcomingEvents[indexPath.row - 2].eta))"
                    return cell
                }else{
                    cell.dateLabel.text = "No Event Date"
                    cell.eventLabel.text = "No Event"
                    cell.membersLabel.text = "0 Friends"
                    cell.destinationLabel.text = "No Destination"
                    cell.infoLabel.text = "Distance : 0 km ETA : 0:0"
                    return cell
                }
                
            }
        } else if todayContent != 0 && upcomingContent == 0{
            if indexPath.row == 0 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeHeaderCell", for: indexPath)) as! HomeHeaderCell
                cell.delegate = self
                return cell
            }else if indexPath.row == 1 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeDateCell", for: indexPath)) as! HomeDateCell
                cell.dateLbl.text = "Today, \(getCurrDate())"
                return cell
            }else {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)) as! HomeCell
                
                if self.todayContent == 0 {
                    cell.dateLabel.text = "No Event Date"
                    cell.eventLabel.text = "No Event"
                    cell.membersLabel.text = "0 Friends"
                    cell.destinationLabel.text = "No Destination"
                    cell.infoLabel.text = "Distance : 0 km ETA : 0:0"
                    return cell
                    
                } else {
                    cell.dateLabel.text = "At \(Pretiffy.formatDate(date: self.todayEvents[indexPath.row-2].date))"
                    cell.eventLabel.text = self.todayEvents[indexPath.row-2].activityID
                    cell.membersLabel.text = "\(self.todayEvents[indexPath.row-2].friends) Friends"
                    cell.destinationLabel.text = "Destination \(self.todayEvents[indexPath.row-2].destination)"
                    cell.infoLabel.text = "Distance \(Pretiffy.getDistance(distance: todayEvents[indexPath.row-2].distance)) ETA \(Pretiffy.getETA(seconds: self.todayEvents[indexPath.row-2].eta))"
                    return cell
                }
            }
        } else{
            if indexPath.row == 0 {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeHeaderCell", for: indexPath)) as! HomeHeaderCell
                cell.delegate = self
                return cell
            }else {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeNoEventCell", for: indexPath)) as! HomeNoEventCell
                return cell
            }
        }
        
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        var rowSelected: Int = 0
//        if indexPath.row != 2 {
//            rowSelected = indexPath.row - upcomingContent
//        }
//
//        Preference.set(value: upcomingEvents[rowSelected].activityID, forKey: .kUserActivity)
//        let userId = Preference.getString(forKey: .kUserEmail) ?? ""
//
//        if upcomingEvents.indices.contains(rowSelected) {
//            let user = User()
//            user.searchUser(userID: userId) { (results) in
//                results.first?.ref?
//                    .updateChildValues(
//                        ["activity":"\(self.upcomingEvents[rowSelected].activityID)"]
//                )
//            }
//
//            let vc = DetailEventVC()
//            vc.activityId = self.upcomingEvents[rowSelected].activityID
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
//    }
}
extension HomeVC{
    func getCurrDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func toDateString(time: Date) -> String {
        // Convert from date to string first
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: time)
        
        // Convert from string to date first
        let dateDateFormatter = DateFormatter()
        dateDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateDateFormatter.locale = NSLocale.current
        dateDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let dateString = dateDateFormatter.date(from: date) else {
            return ""
        }
        
        // then convert date to string again
        let dateFormatterResult = DateFormatter()
        dateFormatterResult.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatterResult.locale = NSLocale.current
        dateFormatterResult.dateFormat = "dd MMMM yyyy"
        let stringDate = dateFormatterResult.string(from: dateString)
        
        return stringDate
    }
}
extension HomeVC : homeCellDelegate{
    func toProfile() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toNewRoute() {
        let vc = CreateEventVC()
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func toJoinEvent() {
        let vc = JoinEventVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}


