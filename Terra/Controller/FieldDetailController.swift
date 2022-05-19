//
//  MyFieldsController.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import UIKit
import MapKit

class FieldDetailController: UIViewController {
    var terraManager = TerraManager()
    var fieldsModel = FieldsModel()
    var fieldDetailModel = FieldDetailModel()
    let locationManager = CLLocationManager()
    var places = [Place]()
    var coordinates = [[[Double]]]()
    var name = String()
    var polygonId = String()
    var center = [Double]()
    var area = Double()
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func satelliteImagery(_ sender: UIButton) {
        
        
        performSegue(withIdentifier: "goToSatelliteImage", sender: self)
    }
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        terraManager.delegateImages = self
        requestLocationAccess()
        addAnnotations()
        
        terraManager.getSecrets()
        terraManager.fetchFieldDetail(polygonId: polygonId)
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
        let latitude = center.last! as Double, longitude = center.first! as Double
        let subtitle = "Lat: \(latitude)\nLon: \(longitude)\nArea (hecs): \(area)"
        let place = Place(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
        places.append(place)
       
        
        mapView?.delegate = self
        mapView?.addAnnotations(places)
        
        var fieldCoords = [CLLocationCoordinate2D]()
        for coord in coordinates.first! {
            
            //fieldCoords.append(CLLocationCoordinate2D(latitude: 1.1, longitude: 22.2))
            fieldCoords.append(CLLocationCoordinate2D(latitude: coord.last!, longitude: coord.first!))
            //fieldCoords.append(CLLocationCoordinate2D(latitude: 22.2, longitude:1.1))
            //print(fieldCoords)
        }
        //print(fieldCoords)
        let fieldOverlay = MKPolyline(coordinates: fieldCoords, count: fieldCoords.count)
        mapView.addOverlay(fieldOverlay)
        
        let centerCoords = CLLocationCoordinate2D(latitude: center.last!, longitude: center.first!)
        
        let viewRegion = MKCoordinateRegion(center: centerCoords, latitudinalMeters: K.Mapkit.zoom, longitudinalMeters: K.Mapkit.zoom)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ViewController
        print(fieldDetailModel.mdlImage ?? "")
        destinationVC.url = fieldDetailModel.mdlImage ?? ""
            
        }
    }


extension FieldDetailController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let polyline = overlay as? MKPolyline {
            let lineRenderer = MKPolylineRenderer(polyline: polyline)
            lineRenderer.strokeColor = K.Mapkit.lineColor
            lineRenderer.lineWidth = K.Mapkit.lineWidth
            return lineRenderer
            
        }
        fatalError("MKMapView rendererFor error: \(Error.self)")
    }
}

extension FieldDetailController : SatelliteImagesDelegate{
    func didUpdateFieldDetail(_ terraManager: TerraManager, fields: FieldDetailModel) {
        fieldDetailModel = fields
        
    }
}
