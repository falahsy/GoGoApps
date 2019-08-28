//
//  TrackingVC.swift
//  cycle
//
//  Created by boy setiawan on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import MapKit

class TrackingVC: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var letsGo: UIButton!{
        didSet{
            letsGo.layer.cornerRadius = letsGo.frame.size.height/2
            letsGo.clipsToBounds = true
            
        }
    }
    
    @IBOutlet weak var sosButton: UIButton!{
        didSet{
            sosButton.layer.cornerRadius = sosButton.frame.size.height/2
            sosButton.clipsToBounds = true
            
        }
    }
    
    let locationManager = CLLocationManager()
    var initialLocation:CLLocationCoordinate2D!
    var routesPoints:[MKPlacemark] = []
    var distanceFromDestination:Double!{
        didSet{
            
            self.distanceLabel.text = "\(Pretiffy.getDistance(distance: self.distanceFromDestination))"
            
            let user = User()
            
            user.searchUser(userID: self.userID!) { (users) in
                users.first?.ref?.updateChildValues(["distance": self.distanceFromDestination ?? 0.0])
            }
        }
    }
    
    var timeFromDestination:Int!{
        didSet{
            
            self.etaLabel.text = "\(Pretiffy.getETA(seconds: self.timeFromDestination))"
            
        }
    }
    var eventDate:Date!{
        didSet{
            self.dayLabel.text = Pretiffy.formatDate(date: self.eventDate)
        }
    }
    var userID:String?
    var activityID:String?
    private var timerForBackground:Timer?
    var messageID = 0
    var friends: [Cyclist] = []
    var sortedFriendsByDistance:[User] = []
    var friendsDistance:[String:Double] = [:]
    var groups:[[String:Double]] = []
    var cyclistOrder:[CyclistInfo] = []
    
    @IBAction func go(_ sender: UIButton) {
        if self.timerForBackground != nil{
            return
        }else{
            backgroundOperation()
        }
        
    }
    @IBAction func sos(_ sender: UIButton) {
        showSOSDialog()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "CyclistCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cyclistCell")
        
        let defaults = UserDefaults.standard
        self.userID = defaults.string(forKey: "email")
        self.activityID = defaults.string(forKey: "activity")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //show user location
        mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        let kegiatan = Activity()
        
        kegiatan.searchActivity(activityID: self.activityID ?? "") { (activities) in
            
            let timeInterval = Double(activities.first!.date)
            let eventDate = Date(timeIntervalSince1970: timeInterval)
            self.eventDate = eventDate
            
            for point in activities.first!.routes{
                let place = MKPlacemark(coordinate: point)
                self.routesPoints.append(place)
                self.addPinInMap(placemark: place)
            }
            
            self.drawRoutes(routes: self.routesPoints)
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.mapView.register(CyclistView.self,
                              forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        self.sortedFriendsByDistance = []
    }
   
    override func viewDidAppear(_ animated: Bool) {
        
        guard let initialLocation = self.initialLocation else {return}
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: initialLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        guard let timer = self.timerForBackground else {return}
        backgroundOperation()
        timer.fire()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        guard let timer = self.timerForBackground else {return}
        timer.invalidate()
        
    }
}

extension TrackingVC:UICollectionViewDelegate{
    
}
extension TrackingVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.sortedFriendsByDistance.count > 0 {
            sortFriendByDistance()
        }
        //return self.sortedFriendsByDistance.count
        return self.cyclistOrder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cyclistCell", for: indexPath) as! CyclistCollectionCell
        
        if self.cyclistOrder.count < 1{
            cell.title?.text = ""
            cell.subtitle?.text = ""
            
        }else{
            cell.title?.text = self.cyclistOrder[indexPath.row].title
            cell.subtitle.text = self.cyclistOrder[indexPath.row].subtitle
            cell.distance.text = self.cyclistOrder[indexPath.row].distance
            
//            cell.subtitle?.text = "\(self.cyclistOrder[indexPath.row].userID) distance \(Pretiffy.getDistance(distance: self.sortedFriendsByDistance[indexPath.row].distance))"
            
        }
        
        return cell
    }
    
    
}

extension TrackingVC: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            self.initialLocation = location.coordinate
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

extension TrackingVC: MKMapViewDelegate{
    
    //MARK:- MapKit delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = RandomHelper.generateRandomColor()
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Cyclist
        
        
    }
}

extension TrackingVC {
    
    func addPinInMap(placemark:MKPlacemark){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let _ = placemark.locality,
            let _ = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
    }
    
    func drawRoutes(routes:[MKPlacemark],draw:Bool = true) {
        
        guard let initialLocation = self.initialLocation else {return}
        self.distanceFromDestination = 0.0
        self.timeFromDestination = 0
        let sourcePlaceMark = MKPlacemark(coordinate: initialLocation)
        var source = MKMapItem(placemark: sourcePlaceMark)
        
        for point in routes{
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = source
            directionRequest.destination = MKMapItem(placemark: point)
            directionRequest.transportType = .any
            
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate { (response, error) in
                guard let directionResonse = response else {
                    if let error = error {
                        print("we have error getting directions==\(error.localizedDescription)")
                    }
                    return
                }
                
                //get route and assign to our route variable
                let route = directionResonse.routes[0]
                
                self.distanceFromDestination += route.distance
                self.timeFromDestination += Int (route.expectedTravelTime)
                
                if draw{
                    
                    //add rout to our mapview
                    self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                    
                    //setting rect of our mapview to fit the two locations
                    let rect = route.polyline.boundingMapRect
                    self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                    
                }
            }
            
            source = MKMapItem(placemark: point)
            
        }
        
    }
}

extension TrackingVC {
    
    func backgroundOperation(){
        
        //background operation
        self.timerForBackground = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (time) in
            
            let kegiatan = Activity()
            
            self.checkSOSMessage(activity:kegiatan)
            
            //MARK:- Real Time Location
            //send real time location
            let user = User()
            
            self.sendRealtimeLocation(user: user)
            //MARK:- Get Friends Location
            self.mapView.removeAnnotations(self.friends)
            
            self.sortedFriendsByDistance = []
            
            user.searchActivity(activity: self.activityID ?? "", callback: { (users) in
                
                self.friends = []
                for cyclist in users{
                    
                    if cyclist.userID != self.userID{
                        self.friends.append(Cyclist(user: cyclist)!)
                    }
                    
                }
                
                //MARK:- Detect distance between check point in route
                var point = 0
                for (index, element) in self.routesPoints.enumerated() {
                    
                    guard let distance = element.location?.distance(from: CLLocation(latitude: self.initialLocation.latitude, longitude: self.initialLocation.longitude)) else {
                        return
                    }
                    
                    if distance < 50 {
                        point = index
                    }
                }
                
                var you:User!
                
                user.searchUser(userID: self.userID!) { (users) in
                    users.first?.ref?.updateChildValues(["point": point])
                    you = users.first!
                    you.fullName = "You"
                    self.sortedFriendsByDistance.append(you)
                    //just in case there are no more friends afterwards
                    //self.collectionView.reloadData()
                    
                }
                
                //MARK:- calculating distance to destination
                let checkPointPassed = self.routesPoints[point...]
                //nedd to do this because the array slice cannot automatically converted
                let checkDistance = Array(checkPointPassed)
                self.mapView.removeOverlays(self.mapView.overlays)
                self.drawRoutes(routes: checkDistance, draw: true)
                
                //MARK:- calculating friends distance to destination
                for friend in  self.friends{
                    user.searchUser(userID: friend.userID, callback: { (users) in
                        self.friendsDistance[users.first!.userID] = users.first!.distance
                    })
                }
                
                //MARK:- Grouping all cyclists
                self.groups = []
                while self.friendsDistance.count > 0 {
                
                let sortedByValueDictionary = self.friendsDistance.sorted { $0.1 < $1.1 }
                guard let initialDistance = sortedByValueDictionary.first?.value else { return }
                
                let filteredDict = self.friendsDistance.filter{
                    Int(($0.value - initialDistance)) < (50 )
                }
                
                if filteredDict.count > 0{
                    
                    self.groups.append(filteredDict)
                    
                    for cyclist in filteredDict{
                        self.friendsDistance.removeValue(forKey: cyclist.key)
                    }
                    
                }
                
                
            }
                
                self.friends = []
                
                for frontCyclist in self.groups{
                    
                    let sortedCyclistInGroup = frontCyclist.sorted { $0.1 < $1.1 }
                    
                    user.searchUser(userID: sortedCyclistInGroup.first!.key, callback: { (users) in
                        
                        var info = ""
                        var detail = ""
                        var user = users.first!
                        
                        if frontCyclist.count > 1 {
                            info = "consists of \(frontCyclist.count ) friends"
                            detail = "\(users.first!.fullName) is in group"
                            user.fullName = info
                            
                        }else{
                            info = users.first?.fullName ?? ""
                            detail = users.first?.userID ?? ""
                        }
                        self.friends.append(Cyclist(fullname: info, userID: detail, discipline: "Flag", coordinate: users.first!.location))
                        
                        self.mapView.addAnnotations(self.friends)
                        
                        self.sortedFriendsByDistance.append(user)
                        
                        self.sortedFriendsByDistance = self.sortedFriendsByDistance.sorted(by: { (user1, user2) -> Bool in return user1.distance < user2.distance
                        })
                        
                        self.collectionView.reloadData()
                    })
                }
                
                self.collectionView.reloadData()
                
                
            })
            
        }
    }
    
    func showSOSMessage(activity:Activity) {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let user = User()
        
        user.searchUser(userID: activity.userID) { (users) in
            
            let user = users.first
            
            let info = "\(user?.fullName ?? "a friend") sends a message '\(activity.message)'"
            let alertController = UIAlertController(title: "SOS", message: info, preferredStyle: .alert)
            
            //the confirm action taking the inputs
            let confirmAction = UIAlertAction(title: "Show Location", style: .default) { (_) in
                
                let defaults = UserDefaults.standard
                defaults.set(user?.userID.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "friendNeedHelp")
                let showRouteVC = ShowRouteVC()
                self.navigationController?.pushViewController(showRouteVC, animated: true)
            }
            
            //        //the cancel action doing nothing
            let cancelAction = UIAlertAction(title: "Acknowledge", style: .cancel) { (_) in
                
                self.messageID = activity.messageID
                
            }
            
            //adding the action to dialogbox
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            //finally presenting the dialog box
            self.present(alertController, animated: true, completion: nil)
        }
        //
        
    }
    
    func showSOSDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title : "SOS", message: "Message", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            //getting the input values from user
            let message = alertController.textFields?[0].text
            
            let kegiatan = Activity()
            
            let messageID = Int.random(in: 1...10000)
            
            kegiatan.searchActivity(activityID: self.activityID ?? "") { (activities) in
                
                for activity in activities{
                    //update values
                    activity.ref?.updateChildValues(["message" : message?.trimmingCharacters(in: .whitespacesAndNewlines),"user": self.userID,"messageID":messageID])
                    
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Message"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkSOSMessage(activity: Activity){
        activity.searchActivity(activityID: self.activityID ?? "") { (activities) in
            
            for activity in activities{
                if  activity.messageID != self.messageID && self.userID != activity.userID  { //
                    //new sos message
                    self.showSOSMessage(activity: activity)
                    
                }
            }
        }
    }
    
    func sendRealtimeLocation(user: User){
        
        user.searchUser(userID: self.userID!, callback: { (users) in
            users.first?.ref?.updateChildValues(["location":"\(self.initialLocation.latitude),\(self.initialLocation.longitude)"])
        })
        
    }
    
    func sortFriendByDistance(){
        
        //MARK:- Count Distance between each group
        
        self.cyclistOrder = []
        guard let _ = self.sortedFriendsByDistance.first else {
            return
        }
        let firstCyclist = self.sortedFriendsByDistance.first!
        
        if firstCyclist.fullName == "You" {
            self.cyclistOrder.append(CyclistInfo(title: "\(firstCyclist.fullName) in 1", subtitle: firstCyclist.userID, distance: Pretiffy.getDistance(distance: firstCyclist.distance)))
        }else{
            let info = "Group 1 \(firstCyclist.fullName)"
            self.cyclistOrder.append(CyclistInfo(title: info, subtitle: firstCyclist.userID, distance: Pretiffy.getDistance(distance: firstCyclist.distance)))
        }
        
        self.sortedFriendsByDistance.enumerated().forEach { (index,element) in
            
            if index == 0 {
                return
            }
            
            var distance = 0.0
            if element.fullName == "You" {
                
                if index == 1{
                    distance = element.distance - firstCyclist.distance
                }
                else{
                    distance = element.distance - self.sortedFriendsByDistance[index - 1].distance
                }
                self.cyclistOrder.append(CyclistInfo(title: "\(element.fullName) in \(index + 1)", subtitle: element.userID, distance: Pretiffy.getDistance(distance: distance)))
                
            }else{
                
                let info = "Group \(index + 1) \(firstCyclist.fullName)"
                if index == 1{
                    distance = element.distance - firstCyclist.distance
                }
                else{
                    distance = element.distance - self.sortedFriendsByDistance[index - 1].distance
                }
                
                self.cyclistOrder.append(CyclistInfo(title: info, subtitle: element.userID, distance: Pretiffy.getDistance(distance: distance)))
            }
            print("called")
            
        }
        
        
    }
}
