//
//  RouteVC.swift
//  cycle
//
//  Created by boy setiawan on 22/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import Foundation

import UIKit
import MapKit


class RouteVC: UIViewController {
    @IBOutlet weak var navbar: UINavigationBar!
    
    let locationManager = CLLocationManager()
    var initialLocation:CLLocationCoordinate2D!
    var resultSearchController:UISearchController? = nil
    var routesPoints:[MKPlacemark] = []
    var selectedPin:MKPlacemark? = nil
    var distanceFromDestination = 0.0
    var timeFromDestination = 0
    var userID:String?
    
    @IBOutlet weak var startingPoint: UITextField!
    @IBOutlet weak var destinationPoint: UITextField!
    @IBOutlet weak var testView: UIView!
    
    @IBOutlet weak var textDate: UILabel!
    @IBOutlet weak var textDuration: UILabel!
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            addButton.layer.cornerRadius = addButton.frame.size.height/2
            addButton.clipsToBounds = true
            
        }
    }
    
    @IBAction func addRoute(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        //show user location
        mapView.showsUserLocation = true
        //set delegate for routetextfiled
        self.startingPoint.delegate = self
        self.destinationPoint.delegate = self
        
        let defaults = UserDefaults.standard
        self.userID = defaults.string(forKey: "email")
        
       
        
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let homeVC = HomeVC()
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    @IBAction func done(_ sender: UIBarButtonItem) {
    }
    
}

extension RouteVC: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            self.initialLocation = location.coordinate
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

extension RouteVC:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.startingPoint{
            let locationSearchTable = SearchRouteVC()
            resultSearchController = UISearchController(searchResultsController: locationSearchTable)
            resultSearchController?.searchResultsUpdater = locationSearchTable
            resultSearchController?.searchBar.delegate = locationSearchTable
            
            let searchBar = resultSearchController!.searchBar
            
            searchBar.sizeToFit()
            searchBar.placeholder = "Search for places"
            self.navbar.topItem?.titleView = resultSearchController?.searchBar
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            resultSearchController?.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true

            locationSearchTable.mapView = mapView
            locationSearchTable.delegate = self
            searchBar.becomeFirstResponder()
            
        }else{
            print("Destination point")
        }
    }
}

extension RouteVC: SearchRouteDelegate {
    
    func cancelRoutes() {
        self.routesPoints = []
        self.mapView.removeOverlays(self.mapView.overlays)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: initialLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        print("Cancel")
        self.navigationItem.prompt = nil
        self.navbar.topItem?.titleView = nil
       
        
//        guard let timer = self.timerForBackground else {return}
//        timer.invalidate()
        
    }
    
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
    
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        
        addPinInMap(placemark: placemark)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        self.routesPoints.append(placemark)
        drawRoutes(routes: self.routesPoints)
    }
    
    func drawRoutes(routes:[MKPlacemark],draw:Bool = true) {
        
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
                
                DispatchQueue.main.async(execute: {
                    
                    let user = User()
                    
                    user.searchUser(userID: self.userID!) { (users) in
                        users.first?.ref?.updateChildValues(["distance": self.distanceFromDestination])
                    }
                    
                    self.textDuration.text = "\(Pretiffy.getETA(seconds: self.timeFromDestination))"
                })
                
                
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

