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
    
    let locationManager = CLLocationManager()
    var initialLocation:CLLocationCoordinate2D!
    var resultSearchController:UISearchController? = nil
    var routesPoints:[MKPlacemark] = []
    var selectedPin:MKPlacemark? = nil
    var distanceFromDestination:Double!{
        didSet{
            let user = User()
            
            user.searchUser(userID: self.userID!) { (users) in
                users.first?.ref?.updateChildValues(["distance": self.distanceFromDestination ?? 0.0])
            }
        }
    }
    var timeFromDestination:Int!{
        didSet{
            
            self.durationLabel.text = "\(Pretiffy.getETA(seconds: self.timeFromDestination))"
            
        }
    }
    var userID:String?
    var activityID:String?
    var eventDate:Date!{
        didSet{
            self.dateLabel.text = Pretiffy.formatDate(date: self.eventDate)
        }
    }
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var hookUpDatePicker: UITextField!
    
    @IBOutlet weak var startingPoint: UITextField!
    @IBOutlet weak var destinationPoint: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            addButton.layer.cornerRadius = addButton.frame.size.height/2
            addButton.clipsToBounds = true
            
        }
    }
    
    @IBAction func addRoute(_ sender: UIButton) {
        
        var routesShared:[CLLocationCoordinate2D] = []
        
        for route in self.routesPoints{
            routesShared.append(route.coordinate)
        }
        self.activityID = "\(Int.random(in: 1...10000))"
        
        //join the user in the activity
        let user = User()
        
        user.searchUser(userID: self.userID!) { (users) in
            for cyclist in users{
                cyclist.ref?.updateChildValues(["activity" : self.activityID!,"point" : 0])
            }
        }
        
        let activity = Activity(id: self.activityID!.trimmingCharacters(in: .whitespacesAndNewlines), routes: routesShared,date:self.eventDate)
        
        activity.insertData { (info) in
            Preference.set(value: self.activityID, forKey: .kUserActivity)
            
            let eventCreatedVC = EventCreatedVC()
            self.navigationController?.pushViewController(eventCreatedVC, animated: true)
            
        }
        
       
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
        startingPoint.delegate = self
        destinationPoint.delegate = self
        
        let defaults = UserDefaults.standard
        userID = defaults.string(forKey: "email")
        mapView.delegate = self
       
        //set tap location in map view
        let selectLocationTap = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureReconizer:)))
        selectLocationTap.minimumPressDuration = 1.5
        selectLocationTap.delaysTouchesBegan = true
        selectLocationTap.delegate = self
        mapView.addGestureRecognizer(selectLocationTap)
        
        eventDate = Date()
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dateTap(_:)))
        dateLabel.addGestureRecognizer(dateTapGesture)
        
        timeFromDestination = 0
        prepareDatePicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let initialLocation = self.initialLocation else {return}
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: initialLocation, span: span)
            mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
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
           
            
            self.navigationController?.navigationBar.topItem?.titleView = resultSearchController?.searchBar
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            resultSearchController?.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true

            locationSearchTable.mapView = mapView
            locationSearchTable.delegate = self
            searchBar.becomeFirstResponder()
            
        }else{
            let destinationSearchTable = SearchRouteDestinationVC()
            resultSearchController = UISearchController(searchResultsController: destinationSearchTable)
            resultSearchController?.searchResultsUpdater = destinationSearchTable
            resultSearchController?.searchBar.delegate = destinationSearchTable
            
            let searchBar = resultSearchController!.searchBar
            
            searchBar.sizeToFit()
            searchBar.placeholder = "Search for places"
            
            
            self.navigationController?.navigationBar.topItem?.titleView = resultSearchController?.searchBar
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            resultSearchController?.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
            
            destinationSearchTable.mapView = mapView
            destinationSearchTable.delegate = self
            searchBar.becomeFirstResponder()
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
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = "Create Route"
        self.startingPoint.text = nil
        
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
        cancelRoutes()
        
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        addPinInMap(placemark: placemark)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        //self.routesPoints.append(placemark)
        self.routesPoints.insert(placemark, at: 0)
        self.startingPoint.text = placemark.title
        
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = "Create Route"
        
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

extension RouteVC: MKMapViewDelegate{
    
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

extension RouteVC:SearchRouteDestinationDelegate{
    func dropPin(placemark: MKPlacemark) {
        
        selectedPin = placemark
        addPinInMap(placemark: placemark)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        self.routesPoints.append(placemark)
        self.destinationPoint.text = placemark.title
        
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = "Create Route"
        
        drawRoutes(routes: self.routesPoints)
        prepareDatePicker()
        
    }
    
    func cancelDestinationRoutes() {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: initialLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        self.destinationPoint.text = nil
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = "Create Route"
        
        if self.routesPoints.count > 1{
            
            self.routesPoints.remove(at: self.routesPoints.count - 1)
        }
        self.mapView.removeOverlays(self.mapView.overlays)
        self.destinationPoint.text = nil
        drawRoutes(routes: self.routesPoints)
        
    }
    
}

extension RouteVC: UIGestureRecognizerDelegate{
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            //print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            let point = MKPlacemark(coordinate: locationCoordinate)
            
            if routesPoints.first(where: { $0.coordinate.latitude == point.coordinate.latitude && $0.coordinate.longitude == point.coordinate.longitude }) != nil{
                
                return
            }
             self.mapView.removeOverlays(self.mapView.overlays)
            addPinInMap(placemark: point)
            self.routesPoints.append(point)
            drawRoutes(routes: self.routesPoints)
            
            return
            
        }
        
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            
            return
        }
    }
}

extension RouteVC {
    
    func prepareDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        self.hookUpDatePicker.inputAccessoryView = toolbar
        // add datepicker to textField
        self.hookUpDatePicker.inputView = datePicker
        
        
        
    }
    
   @objc func donedatePicker(){
    
    self.eventDate = datePicker.date
    self.view.endEditing(true)

    
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    @objc func dateTap( _ recognizer : UITapGestureRecognizer){
        
        hookUpDatePicker.becomeFirstResponder()
    }
}


