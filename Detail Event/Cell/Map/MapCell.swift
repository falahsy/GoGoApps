//
//  MapCell.swift
//  cycle
//
//  Created by Azmi Muhammad on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UITableViewCell {
    
    weak var mapViewDelegate: MKMapViewDelegate?

    static let identifier: String = "MapCell"
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var dayAndDateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var durationView: UIView!
    
    var detailModel: DetailModel? {
        didSet {
            guard let detailModel = detailModel else { return }
            attachToView(detailModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setupView() {
        dateView.setupRadius(type: .custom(8.0))
        distanceView.setupRadius(type: .custom(8.0))
        durationView.setupRadius(type: .custom(8.0))
    }
    
    func setupMapView() {
        mapView.showsUserLocation = true
        mapView.delegate = mapViewDelegate
        mapView.register(CyclistView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    func zoomMap(_ initialLocation: CLLocationCoordinate2D?) {
        guard let initialLocation = initialLocation else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: initialLocation, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func attachToView(_ model: DetailModel) {
        dayAndDateLabel.text = Pretiffy.formatDate(date: model.eventDate)
        distanceLabel.text = Pretiffy.getDistance(distance: model.distanceFromDestination)
        durationLabel.text = Pretiffy.getETA(seconds: model.timeFromDestination)
    }
    
}

extension MapCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = RandomHelper.generateRandomColor()
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
    }
}

extension MapCell {
    func addPinInMap(placemarks: [MKPlacemark]?) {
        guard let placemarks = placemarks else { return }
        placemarks.forEach { (placemark) in
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let _ = placemark.locality,
                let _ = placemark.administrativeArea {
                annotation.subtitle = "(city) (state)"
            }
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func drawRoutes(initialLocation: CLLocationCoordinate2D?, activity: Activity?, draw: Bool = true) {
        
        guard let initialLocation = initialLocation, let activity = activity else { return }
        let timeInterval = Double(activity.date)
        let eventDate = Date(timeIntervalSince1970: timeInterval)
        var distanceFromDestination: Double = 0.0
        var timeFromDestination: Int = 0
        
        var routesPoints: [MKPlacemark] = []
        activity.routes.forEach { (coordinate) in
            let place = MKPlacemark(coordinate: coordinate)
            routesPoints.append(place)
        }

        let sourcePlaceMark = MKPlacemark(coordinate: initialLocation)
        var source = MKMapItem(placemark: sourcePlaceMark)
        
        routesPoints.forEach { (point) in
            let directionRequest = MKDirections.Request()
            directionRequest.source = source
            directionRequest.destination = MKMapItem(placemark: point)
            directionRequest.transportType = .any
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let directionResponse = response else {
                    if let error = error {
                        print("we have error getting directions==\(error.localizedDescription)")
                    }
                    return
                }
                
                let route = directionResponse.routes[0]
                
                distanceFromDestination += route.distance
                timeFromDestination += Int(route.expectedTravelTime)
                
                self.detailModel = DetailModel(distanceFromDestination: distanceFromDestination, timeFromDestination: timeFromDestination, eventDate: eventDate)
                
                if draw {
                    self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                    let rect = route.polyline.boundingMapRect
                    self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                }
            }
            source = MKMapItem(placemark: point)
        }
        
        
    }
}
