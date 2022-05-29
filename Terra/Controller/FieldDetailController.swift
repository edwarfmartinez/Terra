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
    var fieldDetailModel = FieldDetailModel()
    var forecastModel = ForecastModel()
    var soilModel = SoilModel()
    
    let locationManager = CLLocationManager()
    var places = [Place]()
    var coordinates = [[[Double]]]()
    var name = String()
    var polygonId = String()
    var center = [Double]()
    var area = Double()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        terraManager.delegateImages = self
        terraManager.delegateForecast = self
        terraManager.delegateSoil = self
        
        mapView.layer.cornerRadius = K.cornerRadius
        requestLocationAccess()
        addAnnotations()
        terraManager.getSecrets()
        
        terraManager.fetchFieldDetail(polygonId: polygonId)
        terraManager.fetchForecast(lat: center.last!, lon: center.first!)
        terraManager.fetchSoil(polygonId: polygonId)
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print(K.Mapkit.locationAccessErrorMessage)
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func addAnnotations() {
        
        
        let title = name
        let latitude = center.last! as Double, longitude = center.first! as Double
        let subtitle = K.Mapkit.annotationLatLabel + String(latitude) + K.Mapkit.annotationLonLabel + String(longitude) + K.Mapkit.annotationAreaLabel + String(area)
        
        let place = Place(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
        places.append(place)
        
        
        mapView?.delegate = self
        mapView?.addAnnotations(places)
        
        var fieldCoords = [CLLocationCoordinate2D]()
        for coord in coordinates.first! {
            
            fieldCoords.append(CLLocationCoordinate2D(latitude: coord.last!, longitude: coord.first!))
            
        }
        let fieldOverlay = MKPolyline(coordinates: fieldCoords, count: fieldCoords.count)
        mapView.addOverlay(fieldOverlay)
        
        let centerCoords = CLLocationCoordinate2D(latitude: center.last!, longitude: center.first!)
        
        let viewRegion = MKCoordinateRegion(center: centerCoords, latitudinalMeters: K.Mapkit.zoom, longitudinalMeters: K.Mapkit.zoom)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier
        {
        case K.Segues.satSegue:
            let destinationVC = segue.destination as! SatelliteController
            destinationVC.url = fieldDetailModel.mdlUrl ?? ""
            destinationVC.cl = fieldDetailModel.mdlCl ?? 0
            destinationVC.dc = fieldDetailModel.mdlDc  ?? 0
            destinationVC.azimuth = fieldDetailModel.mdlAzimuth ?? 0
            destinationVC.elevation = fieldDetailModel.mdlElevation ?? 0
            
        case K.Segues.forecastSegue:
            let destinationVC = segue.destination as! ForecastController
            destinationVC.pointsTemp = forecastModel.mdlTempPoints!
            destinationVC.pointsClouds = forecastModel.mdlCloudsPoints!
            
        default:
            let destinationVC = segue.destination as! SoilController
            destinationVC.soilModel = soilModel
        }
        
    }
}

//MARK: - MKMapViewDelegate

extension FieldDetailController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyLine = overlay as? MKPolyline {
            let lineRenderer = MKPolylineRenderer(polyline: polyLine)
            lineRenderer.strokeColor = K.Mapkit.lineColor
            lineRenderer.lineWidth = K.Mapkit.lineWidth
            return lineRenderer
        }
        fatalError(K.ErrorMessages.drawPolygonErrorMessage + "\(Error.self)")
    }
}

//MARK: - SatelliteImagesDelegate
extension FieldDetailController : SatelliteImagesDelegate{
    func didUpdateFieldDetail(_ terraManager: TerraManager, fields: FieldDetailModel) {
        DispatchQueue.main.async{
            self.fieldDetailModel = fields
        }
    }
}

//MARK: - ForecastDelegate
extension FieldDetailController : ForecastDelegate{
    func didUpdateForecast(_ terraManager: TerraManager, fields: ForecastModel) {
        DispatchQueue.main.async {
            self.forecastModel = fields
        }
    }
}

//MARK: - SoilDelegate
extension FieldDetailController : SoilDelegate{
    func didUpdateSoil(_ terraManager: TerraManager, fields: SoilModel) {
        DispatchQueue.main.async {
            self.soilModel = fields
        }
    }
}

