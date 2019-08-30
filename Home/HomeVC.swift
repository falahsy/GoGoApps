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
    
    var todayContent = 1
    var upcomingContent = 3
    
    var upcomingEvents:[UpcomingEventInfo]=[]
    @IBOutlet weak var tableView: UITableView!
    func configTableView(){
        tableView.backgroundColor = UIColor(hex: "#F9F9F9")
        tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "homeCell")
        tableView.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellReuseIdentifier: "homeHeaderCell")
        tableView.register(UINib(nibName: "HomeDateCell", bundle: nil), forCellReuseIdentifier: "homeDateCell")
        tableView.register(UINib(nibName: "HomeNoEventCell", bundle: nil), forCellReuseIdentifier: "homeNoEventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavController(title: "GoGo", prefLargeTitle: false, isHidingBackButton: true)
        
        let userID = Preference.getString(forKey: .kUserEmail)!
        let today = Date()
        let tommorow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        let event = Events()
        
        upcomingEvents = []
        event.searchUser(userID: userID) { (events) in
            
            for upcomingEvent in events{
                
                let intervalDate = Double(upcomingEvent.date)
                let eventDate = Date(timeIntervalSince1970: intervalDate)
                
                if tommorow! > eventDate{
                    
                    upcomingEvent.deleteData(callback: { (info) in
                        print(info)
                    })
                    
                }else{
                    
                    upcomingEvent.searchActivity(activityID: upcomingEvent.activityID, callback: { (friendsInCommon) in
                        let userEvent = UpcomingEventInfo(activityID: upcomingEvent.activityID, date: eventDate, friends: friendsInCommon.count - 1, destination: upcomingEvent.destination, distance: upcomingEvent.distance, eta: upcomingEvent.eta)
                        self.upcomingEvents.append(userEvent)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    })
                }
                
                
            }
        }
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
                
                if self.upcomingEvents.count == 0 {
                    cell.dateLabel.text = "No Event Date"
                    cell.eventLabel.text = "No Event"
                    cell.membersLabel.text = "0 Friends"
                    cell.destinationLabel.text = "No Destination"
                    cell.infoLabel.text = "Distance : 0 km ETA : 0:0"
                    return cell
                    
                }
                cell.dateLabel.text = "At \(Pretiffy.formatDate(date: self.upcomingEvents[0].date))"
                cell.eventLabel.text = self.upcomingEvents[0].activityID
                cell.membersLabel.text = "\(self.upcomingEvents[0].friends) Friends"
                cell.destinationLabel.text = "Destination \(self.upcomingEvents[0].destination)"
                cell.infoLabel.text = "Distance \(Pretiffy.getDistance(distance: upcomingEvents[0].distance)) ETA \(Pretiffy.getETA(seconds: self.upcomingEvents[0].eta))"
                return cell
            }else if indexPath.row == todayContent + 2{
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeDateCell", for: indexPath)) as! HomeDateCell
                cell.dateLbl.text = "Upcoming Events"
                return cell
            }else{
                let cell = (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)) as! HomeCell
                
                if self.upcomingEvents.indices.contains(indexPath.row - upcomingContent){
                    cell.dateLabel.text = "At \(Pretiffy.formatDate(date: self.upcomingEvents[indexPath.row - upcomingContent].date))"
                    cell.eventLabel.text = self.upcomingEvents[indexPath.row - upcomingContent].activityID
                    cell.membersLabel.text = "\(self.upcomingEvents[indexPath.row - upcomingContent].friends) Friends"
                    cell.destinationLabel.text = "Destination \(self.upcomingEvents[indexPath.row - upcomingContent].destination)"
                    cell.infoLabel.text = "Distance \(Pretiffy.getDistance(distance: self.upcomingEvents[indexPath.row - upcomingContent].distance)) ETA \(Pretiffy.getETA(seconds: self.upcomingEvents[indexPath.row - upcomingContent].eta))"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailEventVC()
        vc.activityId = upcomingEvents[indexPath.row].activityID
        navigationController?.pushViewController(vc, animated: true)
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


