//
//  CreateEventVC.swift
//  cycle
//
//  Created by boy setiawan on 22/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import Foundation

import UIKit
import MapKit


class CreateEventVC: UIViewController {
    
    let locationManager = CLLocationManager()
    var initialLocation:CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        //show user location
        mapView.showsUserLocation = true
        //set delegate for mapview

    }
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var createButton: UIButton!{
        didSet{
            createButton.layer.cornerRadius = createButton.frame.size.height/2
            createButton.clipsToBounds = true
            
        }
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createEvent(_ sender: UIButton) {
        let routeVC = RouteVC()
        self.navigationController?.pushViewController(routeVC, animated: true)
    }
}

extension CreateEventVC: CLLocationManagerDelegate {
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
