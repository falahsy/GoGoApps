//
//  DetailEventVC.swift
//  cycle
//
//  Created by Azmi Muhammad on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
import MapKit

class DetailEventVC: UIViewController {

    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.setupRadius(type: .custom(12.0))
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.register(UINib(nibName: MapCell.identifier, bundle: nil), forCellReuseIdentifier: MapCell.identifier)
            tableView.register(UINib(nibName: TeamCell.identifier, bundle: nil), forCellReuseIdentifier: TeamCell.identifier)
            tableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    
    var activityId: String = ""
    var userId: String = ""
    var activity: Activity?
    var timer: Timer?
    var placemarks: [MKPlacemark] = []
    var members: [User]?
    
    let locationManager: CLLocationManager = CLLocationManager()
    var initialLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController(title: "Detail Event", prefLargeTitle: true, isHidingBackButton: false)
        view.backgroundColor = UIColor(hex: "#F9F9F9")
        
        setupLocationManager()
        getDetailActivity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func getDetailActivity() {
        let detailActivity: Activity = Activity()
        
        detailActivity.searchActivity(activityID: activityId) { [weak self] (results) in
            guard let self = self else { return }
            self.activity = results.first
            self.activity?.routes.forEach({ (coordinate) in
                let place = MKPlacemark(coordinate: coordinate)
                self.placemarks.append(place)
            })
        }
        getMembers()
    }
    
    private func getMembers() {
        let user: User = User()
        user.searchActivity(activity: activityId) { (users) in
            self.members = users
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func onStartTapped(_ sender: UIButton) {
        let vc: LoadingVC = LoadingVC()
        vc.activity = activity
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true, completion: nil)
    }
}

extension DetailEventVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellForMapView(tableView, indexPath)
        case 1:
            return cellForMemberView(tableView, indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func cellForMapView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MapCell.identifier, for: indexPath) as? MapCell else { return UITableViewCell() }
        cell.mapViewDelegate = self
        cell.setupMapView()
        cell.zoomMap(initialLocation)
        cell.addPinInMap(placemarks: placemarks)
        cell.drawRoutes(initialLocation: initialLocation, activity: activity)
        return cell
    }

    private func cellForMemberView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.identifier, for: indexPath) as? TeamCell else { return UITableViewCell() }
        cell.members = members
        return cell
    }
}

extension DetailEventVC: CLLocationManagerDelegate, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = RandomHelper.generateRandomColor()
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            initialLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}
