//
//  ShowRouteVC.swift
//  cycle
//
//  Created by boy setiawan on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class ShowRouteVC: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sosButton: UIButton!
    
    let locationManager = CLLocationManager()
    var initialLocation:CLLocationCoordinate2D!
    var userID:String?
    var activityID:String?
    var userNeedHelp:User!
    var messageID = 0
    private var timerForBackground:Timer?
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBAction func sos(_ sender: UIButton) {
        showSOSDialog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //show user location
        mapView.showsUserLocation = true
        //set delegate for mapview
        self.mapView.delegate = self
        
        let defaults = UserDefaults.standard
        self.userID = defaults.string(forKey: "email")
        self.activityID = defaults.string(forKey: "activity")
        let idUserNeedHelp = defaults.string(forKey: "friendNeedHelp")
        
        let user = User()
        
        user.searchUser(userID: idUserNeedHelp ?? "", callback: { (users) in
                self.userNeedHelp = users.first!
        })
       
        //backGroundOperation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let initialLocation = self.initialLocation else {return}
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: initialLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        backGroundOperation()
        
        
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

extension ShowRouteVC : CLLocationManagerDelegate {
    
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

extension ShowRouteVC: MKMapViewDelegate{
    
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

extension ShowRouteVC {
    func backGroundOperation(){
        //background operation
        self.timerForBackground = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (time) in
            
            //check sos message
            let kegiatan = Activity()
            kegiatan.searchActivity(activityID: self.activityID ?? "" ) { (activities) in
                
                for activity in activities{
                    if  activity.messageID != self.messageID && self.userID != activity.userID { //
                        //new sos message
                        self.showSOSMessage(activity: activity)
                        
                    }
                }
            }
            
            //monitor friends location
            let user = User()
            
            user.searchUser(userID: self.userNeedHelp.userID ?? "") { (users) in
                self.userNeedHelp = users.first
                self.cancelRoutes()
                self.addPinInMap(placemark: self.userNeedHelp.location)
                self.drawRoutes()
            }
            
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
            
            //        //the cancel action doing nothing
            let cancelAction = UIAlertAction(title: "Acknowledge", style: .cancel) { (_) in
                
                self.messageID = activity.messageID
                
            }
            
            //adding the action to dialogbox
            alertController.addAction(cancelAction)
            
            //finally presenting the dialog box
            self.present(alertController, animated: true, completion: nil)
        }
        //
        
    }
    
    func addPinInMap(placemark:CLLocationCoordinate2D){
        
        let friendCoordinate = MKPlacemark(coordinate: placemark)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = friendCoordinate.coordinate
        annotation.title = friendCoordinate.name
        if let _ = friendCoordinate.locality,
            let _ = friendCoordinate.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        
    }
    
    
    func cancelRoutes() {
        
        self.mapView.removeOverlays(self.mapView.overlays)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: initialLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        
        
    }
    
    func drawRoutes(){
        
        let sourcePlaceMark = MKPlacemark(coordinate: initialLocation)
        
        let directionRequest = MKDirections.Request()
        let source = MKMapItem(placemark: sourcePlaceMark)
        let friendCoordinate = MKPlacemark(coordinate: userNeedHelp.location)
        
        directionRequest.source = source
        directionRequest.destination = MKMapItem(placemark: friendCoordinate)
        directionRequest.transportType = .walking
        
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
            
            //test
            print("route.distance = \(Pretiffy.getDistance(distance: route.distance))")
            self.distanceLabel.text = "\(Pretiffy.getDistance(distance: route.distance))"
            //end
            
            //add rout to our mapview
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            //setting rect of our mapview to fit the two locations
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        
        
        
    }
    
    func showSOSDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "SOS", message: "Message", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            //getting the input values from user
            let message = alertController.textFields?[0].text
            
            let kegiatan = Activity()
            
            let messageID = Int.random(in: 1...10000)
            
            kegiatan.searchActivity(activityID: self.activityID ?? "" ) { (activities) in
                
                for activity in activities{
                    //update values
                    activity.ref?.updateChildValues(["message" : message?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "","user": self.userID ?? "","messageID":messageID])
                    
                }
            }
            
        }
        
        //        //the cancel action doing nothing
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
}
