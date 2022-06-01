//
//  FieldsManager.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//
import UIKit
import Foundation

protocol TerraManagerDelegate {
    
    func didUpdateFields(_ terraManager: TerraManager, fields: FieldsModel)
    func didFailWithError(error: Error)
}

protocol SatelliteImagesDelegate{
    func didUpdateFieldDetail(_ terraManager: TerraManager, fields: FieldDetailModel)
}

protocol ForecastDelegate{
    func didUpdateForecast(_ terraManager: TerraManager, fields: ForecastModel)
}

protocol SoilDelegate{
    func didUpdateSoil(_ terraManager: TerraManager, fields: SoilModel)
}

struct TerraManager {
    
    var delegate : TerraManagerDelegate?
    var delegateImages : SatelliteImagesDelegate?
    var delegateForecast : ForecastDelegate?
    var delegateSoil : SoilDelegate?
    //var fieldsModelT = FieldsModel()
    
    var apiKey : String?
    //MARK: - Get Secrets
    mutating func getSecrets(){
        var config: [String: Any]?
        if let infoPlistPath = Bundle.main.url(forResource: K.Secrets.fileName, withExtension: K.Secrets.fileExtension)
        {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    config = dict
                    apiKey = config?[K.Secrets.apiKeyName] as? String
                }
            } catch {
                print(K.ErrorMessages.getSecrets + "\(error)")
            }
        }
    }
    
    //MARK: - Fetch Fields
    
    func fetchFields(){
        var url = URLComponents(string: K.TerraUrl.myFields)
        url?.queryItems![0].value = apiKey
        
        fetchGenericData(urlString: (url?.string)!) { (fields: [FieldsData]) in
            var fieldsT = FieldsModel()
            fields.forEach({
                fieldsT.mdlName?.append($0.name)
                fieldsT.mdlArea?.append($0.area)
                fieldsT.mdlCenter?.append($0.center)
                fieldsT.mdlCoordinates?.append($0.geoJSON.geometry.coordinates)
                fieldsT.mdlId?.append($0.id)
            })
            self.delegate?.didUpdateFields(self, fields: fieldsT)
        }
    }
    
    //MARK: - Fetch FieldDetail
    
    func fetchFieldDetail(polygonId: String){
        
        var dateComponent = DateComponents()
        dateComponent.month = K.SatelliteImages.imageMonths
        let end = Date().timeIntervalSince1970
        let start = (Calendar.current.date(byAdding: dateComponent, to: Date()))?.timeIntervalSince1970
        
        var url = URLComponents(string: K.TerraUrl.field)
        url?.queryItems![0].value = apiKey
        url?.queryItems![1].value = polygonId
        url?.queryItems![2].value = String(end)
        url?.queryItems![3].value = String(start!)
        
        fetchGenericData(urlString: (url?.string)!) {
            (fields: [FieldDetailData]) in
            var fieldsT = FieldDetailModel()
            if !fields.isEmpty{
                
                var urlImage = URLComponents(string: (fields.last?.image.ndvi)!)
                urlImage?.scheme = K.secureScheme
                
                fieldsT.mdlUrl = urlImage?.string
                fieldsT.mdlDc = fields.last?.dc
                fieldsT.mdlCl = roundNumber(num: fields.last!.cl)
                fieldsT.mdlAzimuth = roundNumber(num: (fields.last?.sun.azimuth)!)
                fieldsT.mdlElevation = roundNumber(num: (fields.last?.sun.elevation)!)
                
            }
            self.delegateImages?.didUpdateFieldDetail(self, fields: fieldsT)
        }
    }
    
    //MARK: - Fetch Soil
    
    func fetchSoil(polygonId: String){
        
        var url = URLComponents(string: K.TerraUrl.soil)
        url?.queryItems![0].value = polygonId
        url?.queryItems![1].value = apiKey
        
        fetchGenericData(urlString: (url?.string)!) {
            (fields: SoilData) in
            let fieldsT = SoilModel()
            
            fieldsT.dt = fields.dt
            fieldsT.t10 = roundNumber(num: fields.t10 - K.kelvinToCelsiusConstant)
            fieldsT.t0 = roundNumber(num: fields.t0 - K.kelvinToCelsiusConstant)
            fieldsT.moisture = roundNumber(num: fields.moisture * K.decimalPlacesFactor)
            
            self.delegateSoil?.didUpdateSoil(self, fields: fieldsT)
        }
    }
    
    //MARK: - Fetch Forecast
    func fetchForecast(lat: Double, lon: Double){
        var url = URLComponents(string: K.TerraUrl.forecast)
        
        url?.queryItems![0].value = String(lat)
        url?.queryItems![1].value = String(lon)
        url?.queryItems![2].value = apiKey
        
        fetchGenericData(urlString: (url?.string)!) { (fields: [ForecastData]) in
            var fieldsT = ForecastModel()
            let formatter = DateFormatter()
            
            formatter.dateFormat = K.Chart.dateFormat
            fields.forEach({
                let date = NSDate(timeIntervalSince1970: TimeInterval($0.dt))
                let dateString = formatter.string(from: date as Date)
                
                fieldsT.mdlTempPoints!.append(chartPoints(date: dateString, point: $0.main.temp - K.kelvinToCelsiusConstant))
                fieldsT.mdlCloudsPoints!.append(chartPoints(date: dateString, point: Double($0.clouds.all)))
            })
            self.delegateForecast?.didUpdateForecast(self, fields: fieldsT)
        }
    }
    
    func roundNumber(num: Double) -> Double{
        return round(num * K.decimalPlacesFactor)/K.decimalPlacesFactor
    }
    
    //MARK: - Generics implementation
    
    func fetchGenericData<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, resp, err) in
            if let err = err {
                print(K.ErrorMessages.fetchData, err)
                return
            }
            guard let data = data else { return }
            
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj)
            } catch let jsonErr {
                print(K.ErrorMessages.decodeJson, jsonErr)
            }
        }.resume()
    }
}
