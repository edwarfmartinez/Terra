//
//  SoilController.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 24/05/22.
//

import Foundation
import UIKit

class SoilController: UIViewController{
    
    var soilModel = SoilModel()
    
    @IBOutlet weak var lblT10: UILabel!
    @IBOutlet weak var imgT10: UIImageView!
    @IBOutlet weak var imgT0: UIImageView!
    @IBOutlet weak var lblT0: UILabel!
    @IBOutlet weak var lblMoisture: UILabel!
    @IBOutlet weak var imgDrop1: UIImageView!
    @IBOutlet weak var imgDrop2: UIImageView!
    @IBOutlet weak var imgDrop3: UIImageView!
    @IBOutlet weak var imgDrop4: UIImageView!
    @IBOutlet weak var imgDrop5: UIImageView!
    @IBOutlet weak var t10View: UIStackView!
    @IBOutlet weak var t0View: UIStackView!
    @IBOutlet weak var moistureView: UIStackView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        t10View.layer.cornerRadius = K.cornerRadius
        t0View.layer.cornerRadius = K.cornerRadius
        moistureView.layer.cornerRadius = K.cornerRadius
        
        lblT10.text = String(soilModel.t10)
        lblT0.text = String(soilModel.t0)
        lblMoisture.text = String(soilModel.moisture)
        
        imgT10.image = UIImage(systemName: soilModel.getImage(temperature: soilModel.t10))
        imgT0.image = UIImage(systemName: soilModel.getImage(temperature: soilModel.t0))
        
        imgDrop1.tintColor = soilModel.drop1
        imgDrop2.tintColor = soilModel.drop2
        imgDrop3.tintColor = soilModel.drop3
        imgDrop4.tintColor = soilModel.drop4
        imgDrop5.tintColor = soilModel.drop5
        
    }
}

