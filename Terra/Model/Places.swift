//
//  FieldsData.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import MapKit

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

