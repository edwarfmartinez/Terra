//
//  MyFieldsController.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import UIKit
import MapKit

class FieldDetailController: UIViewController, MKMapViewDelegate {
    
    var terraManager = TerraManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func satelliteImagery(_ sender: UIButton) {
        
        terraManager.getUrl()
        
    }
    
    
    let locationManager = CLLocationManager()
    
    var places = [Place]()
    var coordinates = [[Double]]()
    var name = String()
    var center = [Double]()
    var area = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAccess()
        addAnnotations()
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func addAnnotations() {
        
        let title = name
        let subtitle = "Lat: \(center[1])\nLon: \(center[0])\nArea (hecs): \(area)"
        let latitude = center[1] as? Double ?? 0, longitude = center[0] as? Double ?? 0
        let place = Place(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
        places.append(place)
        
        mapView?.delegate = self
        mapView?.addAnnotations(places)
        
        var fieldCoords = [CLLocationCoordinate2D]()
        for coord in coordinates {
            fieldCoords.append(CLLocationCoordinate2D(latitude: coord[1], longitude: coord[0]))
        }
        
        let fieldOverlay = MKPolyline(coordinates: fieldCoords, count: fieldCoords.count)
        mapView.addOverlay(fieldOverlay)
        
        let centerCoords = CLLocationCoordinate2D(latitude: center[1], longitude: center[0])
        
        let viewRegion = MKCoordinateRegion(center: centerCoords, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(viewRegion, animated: false)
    }
    
}

extension FieldDetailController {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let polyline = overlay as? MKPolyline {
            let lineRenderer = MKPolylineRenderer(polyline: polyline)
            lineRenderer.strokeColor = .blue
            lineRenderer.lineWidth = 2.0
            return lineRenderer
            
        }
        fatalError("MKMapView rendererFor error: \(Error.self)")
    }
}
