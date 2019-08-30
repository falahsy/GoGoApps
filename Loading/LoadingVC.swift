//
//  LoadingVC.swift
//  cycle
//
//  Created by Azmi Muhammad on 28/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //change to true
    var hasReceivedNotification: Bool! {
        didSet {
            setupView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        observeNotification()
    }
    
    private func setupView() {
        if hasReceivedNotification {
            
        } else {
            observeWatch()
        }
    }
    
    private func observeNotification() {
        let shared = AppDelegate.shared
        let eventId = shared.eventID
    }

    private func observeWatch() {
//        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (time) in
//            print("Background")
//            let kegiatan = Activity()
        
//            checkSOSMessage(activity: kegiatan)
            
            //MARK:- Real Time Location
            //send real time location
//            let user = User()
            
//            sendRealtimeLocation(user: user)
            //MARK:- Get Friends Location
//            mapView.removeAnnotations(friends)
            
//            sortedFriendsByDistance = []
            
//            user.searchActivity(activity: activityID ?? "", callback: { (users) in
//                self.friends = []
//                for cyclist in users {
//                    if cyclist.userID != self.userID{
//                        self.friends.append(Cyclist(user: cyclist)!)
//                    }
//
//                }
            
                //MARK:- Detect distance between check point in route
//                var point = 0
//                for (index, element) in self.routesPoints.enumerated() {
//
//                    guard let distance = element.location?.distance(from: CLLocation(latitude: self.initialLocation.latitude, longitude: self.initialLocation.longitude)) else {
//                        return
//                    }
//
//                    if distance < 50 {
//                        point = index
//                    }
//                }
            
//                var you:User!
//
//                user.searchUser(userID: self.userID!) { (users) in
//                    users.first?.ref?.updateChildValues(["point": point])
//                    you = users.first!
//                    you.fullName = "You"
//                    self.sortedFriendsByDistance.append(you)
                    //just in case there are no more friends afterwards
                    //self.collectionView.reloadData()
                    
//                }
            
                //MARK:- calculating distance to destination
//                let checkPointPassed = self.routesPoints[point...]
                //nedd to do this because the array slice cannot automatically converted
//                let checkDistance = Array(checkPointPassed)
//                self.mapView.removeOverlays(self.mapView.overlays)
//                self.drawRoutes(routes: checkDistance, draw: true)
            
                //MARK:- calculating friends distance to destination
//                for friend in  self.friends{
//                    user.searchUser(userID: friend.userID, callback: { (users) in
//                        self.friendsDistance[users.first!.userID] = users.first!.distance
//                    })
//                }
            
                //MARK:- Grouping all cyclists
//                self.groups = []
//                while self.friendsDistance.count > 0 {
//
//                    let sortedByValueDictionary = self.friendsDistance.sorted { $0.1 < $1.1 }
//                    guard let initialDistance = sortedByValueDictionary.first?.value else { return }
//
//                    let filteredDict = self.friendsDistance.filter{
//                        Int(($0.value - initialDistance)) < (50 )
//                    }
//
//                    if filteredDict.count > 0{
//
//                        self.groups.append(filteredDict)
//
//                        for cyclist in filteredDict{
//                            self.friendsDistance.removeValue(forKey: cyclist.key)
//                        }
//
//                    }
//
//
//                }
            
//                self.friends = []
//
//                for frontCyclist in self.groups {
//
//                    let sortedCyclistInGroup = frontCyclist.sorted { $0.1 < $1.1 }
//
//                    user.searchUser(userID: sortedCyclistInGroup.first!.key, callback: { (users) in
//
//                        var info = ""
//                        var detail = ""
//                        var user = users.first!
//
//                        if frontCyclist.count > 1 {
//                            info = "consists of \(frontCyclist.count ) friends"
//                            detail = "\(users.first!.fullName) is in group"
//                            user.fullName = info
//
//                        }else{
//                            info = users.first?.fullName ?? ""
//                            detail = users.first?.userID ?? ""
//                        }
//                        self.friends.append(Cyclist(fullname: info, userID: detail, discipline: "Flag", coordinate: users.first!.location))
//
//                        self.mapView.addAnnotations(self.friends)
//
//                        self.sortedFriendsByDistance.append(user)
//
//                        self.sortedFriendsByDistance = self.sortedFriendsByDistance.sorted(by: { (user1, user2) -> Bool in return user1.distance < user2.distance
//                        })
//
//                        self.collectionView.reloadData()
//                    })
//                }
//
//                self.collectionView.reloadData()
            
                
//            })
            
//        }
    }
}
