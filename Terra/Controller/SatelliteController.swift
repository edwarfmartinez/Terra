//
//  ViewController.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import UIKit
import WebKit

class SatelliteController: UIViewController  {
    
    var url = String()
    var dc = Int()
    var cl = Double()
    var azimuth = Double()
    var elevation = Double()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblDc: UILabel!
    @IBOutlet weak var lblCl: UILabel!
    @IBOutlet weak var lblAzimut: UILabel!
    @IBOutlet weak var lblElevation: UILabel!
    @IBOutlet weak var ndviConventionsView: UIView!
    @IBOutlet weak var ndviConventionsStack: UIStackView!
    @IBOutlet weak var azimutView: UIStackView!
    @IBOutlet weak var elevationView: UIStackView!
    @IBOutlet weak var cloudCoverageView: UIStackView!
    @IBOutlet weak var dataCoverageView: UIStackView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        lblDc.text = String(dc)
        lblCl.text = String(cl)
        lblAzimut.text = String(azimuth)
        lblElevation.text = String(elevation)
        
        ndviConventionsView.layer.cornerRadius = K.cornerRadius
        azimutView.layer.cornerRadius = K.cornerRadius
        elevationView.layer.cornerRadius = K.cornerRadius
        cloudCoverageView.layer.cornerRadius = K.cornerRadius
        dataCoverageView.layer.cornerRadius = K.cornerRadius
        
        
        
        if !url.isEmpty {
            let urlImage = URL(string : url)!
            let data = try? Data(contentsOf: urlImage)
            imageView.image = UIImage(data: data!)
            
        }
    }
}

