//
//  ForecastModel.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 19/05/22.
//

import Foundation

 struct ForecastModel
 {
    var mdlTempPoints:[chartPoints]?
    var mdlCloudsPoints:[chartPoints]?
    
    init(mdlTempPoints: [chartPoints]?=[], mdlCloudsPoints: [chartPoints]?=[]) {
        self.mdlTempPoints = mdlTempPoints
        self.mdlCloudsPoints = mdlCloudsPoints
    }
    
 }

struct chartPoints {
    var date: String
    var point: Double
    
    init(date: String="", point: Double=0.0) {
        self.date=date
        self.point=point
    }
}
