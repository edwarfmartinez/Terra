//
//  FieldsModel.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import Foundation
import MapKit

 struct FieldDetailModel
 {
    var mdlUrl: String?
    var mdlDc: Int?
    var mdlCl: Double?
    var mdlAzimuth: Double?
    var mdlElevation: Double?
    
    init(mdlImage:String = "", mdlDc:Int = 0, mdlCl:Double = 0.0, mdlAzimuth:Double = 0.0, mdlElevation:Double=0.0) {
        
        self.mdlUrl = mdlImage
        self.mdlDc = mdlDc
        self.mdlCl = mdlCl
        self.mdlAzimuth = mdlAzimuth
        self.mdlElevation = mdlElevation
    }
    

 }

@objc class Place: NSObject {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}

extension Place: MKAnnotation { }
