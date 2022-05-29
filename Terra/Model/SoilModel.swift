//
//  SoilModel.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 24/05/22.
//

import Foundation
import UIKit

class SoilModel {
    
    
    var dt: Int
    var t10, moisture, t0: Double
    var drop1: UIColor { moisture >= K.Soil.moisterLevel1 ? K.Soil.dropColorOn : K.Soil.dropColorOff}
    var drop2: UIColor { moisture >= K.Soil.moisterLevel1 && moisture < K.Soil.moisterLevel2 ? K.Soil.dropColorOn : K.Soil.dropColorOff}
    var drop3: UIColor { moisture >= K.Soil.moisterLevel2 && moisture < K.Soil.moisterLevel3 ? K.Soil.dropColorOn : K.Soil.dropColorOff}
    var drop4: UIColor { moisture >= K.Soil.moisterLevel3 && moisture < K.Soil.moisterLevel4 ? K.Soil.dropColorOn : K.Soil.dropColorOff}
    var drop5: UIColor { moisture >= K.Soil.moisterLevel4 ? K.Soil.dropColorOn : K.Soil.dropColorOff}
    
    init(dt:Int = 0, t10:Double=0.0, moisture:Double=0.0, t0:Double=0.0, t0ImageName: String="", t10ImageName: String="") {
        self.dt = dt
        self.t10 = t10
        self.moisture = moisture
        self.t0 = t0
        
    }
    
    func getImage(temperature: Double)->String{
        switch temperature {
        case ..<(K.Soil.tempLevel1):
            return K.Soil.thermometerSnowflake
        case (K.Soil.tempLevel1)..<(K.Soil.tempLevel2):
            return K.Soil.thermometer
        case (K.Soil.tempLevel2)..<(K.Soil.tempLevel3):
            return K.Soil.thermometerSun
        default:
            return K.Soil.thermometerSunFill
        }
    }
}


