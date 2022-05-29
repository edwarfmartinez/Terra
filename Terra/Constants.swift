//
//  Constants.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 16/05/22.
//
import UIKit

struct K {
    
    static let secureScheme =  "https"
    static let decimalPlacesFactor =  100.0
    static let kelvinToCelsiusConstant = 273.15
    static let cornerRadius : CGFloat = 20.0
    
    
    struct Chart{
        static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        static let xAxisDateFormat = "MM-dd"
        static let yAxisTextChart1 = "\nTEMPERATURE FORECAST (°C)"
        static let yAxisTextChart2 = "\nCLOUDS COVERAGE FORECAST (%)"
        static let dateFormatLocale = "en_US_POSIX"
    }
   
    
    struct Mapkit {
        static let locationAccessErrorMessage = "Location access denied"
        static let zoom = 5000.0
        static let lineColor = UIColor(ciColor: .blue)
        static let lineWidth = CGFloat(3.0)
        static let annotationLatLabel = "Lat: "
        static let annotationLonLabel = "\nLon: "
        static let annotationAreaLabel = "\nArea (hecs): "
       
    }
    
    struct SatelliteImages {
        static let imageMonths = -8
    }
    
    struct Segues{
        static let satSegue = "Satellite"
        static let detailSegue = "GoToDetail"
        static let forecastSegue = "Forecast"
    }
    
    struct TableViewComponents{
        static let cellIdentifier = "Cell"
        static let textColor:UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        static let numberOfLines = 0
    }
    
    struct ErrorMessages{
        static let drawPolygonErrorMessage = "Error drawing field: "
        static let fieldsManagerDelegateErrorMessage = "FieldsManagerDelegate error: "
        static let getSecrets = "Failed to get secret: "
        static let fetchData = "Failed to fetch data: "
        static let decodeJson = "Failed to decode json: "
    }
    
    struct Secrets{
        static let fileName = "Secrets"
        static let fileExtension = "plist"
        static let apiKeyName = "ApiKey"
    }
    
    struct TerraUrl{
        static let myFields = "https://api.agromonitoring.com/agro/1.0/polygons?appid="
        static let field = "https://api.agromonitoring.com/agro/1.0/image/search?appid=&polyid=&end=&start="
        static let forecast = "https://api.agromonitoring.com/agro/1.0/weather/forecast?lat=&lon=&appid="
        static let soil = "https://api.agromonitoring.com/agro/1.0/soil?polyid=&appid="
    }
    

    
    struct Soil{
        static let dropColorOn : UIColor =  UIColor(named: "BrandGreen")!
        
        static let dropColorOff : UIColor = UIColor(named: "BrandLightGray")!
                                                           
        static let moisterLevel1 = 20.0
        static let moisterLevel2 = 40.0
        static let moisterLevel3 = 60.0
        static let moisterLevel4 = 90.0
        
        static var thermometer = "thermometer"
        static var thermometerSnowflake = "thermometer.snowflake"
        static var thermometerSun = "thermometer.sun"
        static var thermometerSunFill = "thermometer.sun.fill"
        
        static let tempLevel1 = 8.0
        static let tempLevel2 = 15.0
        static let tempLevel3 = 22.0
    }
    
}
