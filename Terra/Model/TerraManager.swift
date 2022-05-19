//
//  FieldsManager.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import Foundation

protocol TerraManagerDelegate {
    // func didUpdateFields(_ terraManager: TerraManager, fields: FieldsModel)
    func didUpdateFields(_ terraManager: TerraManager, fields: FieldsModel)
    func didFailWithError(error: Error)
}

protocol SatelliteImagesDelegate{
    func didUpdateFieldDetail(_ terraManager: TerraManager, fields: FieldDetailModel)
}

struct TerraManager {
    
    var delegate : TerraManagerDelegate?
    var delegateImages : SatelliteImagesDelegate?
    
    var fieldsURL : String?
    var apiKey : String?
    
    mutating func getSecrets(){
        var config: [String: Any]?
        if let infoPlistPath = Bundle.main.url(forResource: "Secrets", withExtension: "plist")
        {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    config = dict
                    fieldsURL = config?["FieldsURL"] as? String
                    apiKey = config?["ApiKey"] as? String
                }
            } catch {
                print("There was an error getting the Url: \(error)")
            }
        }
    }
    
    func fetchFields(){
        fetchGenericData(urlString: "\(fieldsURL!)\(apiKey!)") { (fields: [FieldsData]) in
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
    
    func fetchFieldDetail(polygonId: String){
        
        var dateComponent = DateComponents()
        dateComponent.month = K.Images.imageMonths
        
        let end = Date().timeIntervalSince1970
        let start = (Calendar.current.date(byAdding: dateComponent, to: Date()))?.timeIntervalSince1970
        
        print("Start: \(start!)  End: \(end) polygonId: \(polygonId) apikey: \(apiKey!)")
        
        fetchGenericData(urlString: "https://api.agromonitoring.com/agro/1.0/image/search?appid=\(apiKey!)&polyid=\(polygonId)&end=\(end)&start=\(start!)") { (fields: [FieldDetailData]) in
            var fieldsT = FieldDetailModel()
            fieldsT.mdlImage = fields.last?.image.truecolor
            
            self.delegateImages?.didUpdateFieldDetail(self, fields: fieldsT)
        }
    }
    
    
    
    //   func performRequest(with urlString: String)
    //    {
    //        //1. Create a Url
    //
    //        if let url = URL(string: urlString){
    //            //2. Create a URLSession
    //            let session = URLSession(configuration: .default)
    //
    //            //3. Give the session a task
    //
    //            let task = session.dataTask(with: url){ (data, response, error) in
    //                if error != nil {
    //                    //delegate?.didFailWithError(error: error!)
    //                    print(error!)
    //                    return
    //                }
    //                if let safeData = data {
    //                    if let fields = self.parseJSON(safeData){
    //                        self.delegate?.didUpdateFields(self, fields:fields)
    //                    }
    //                }
    //            }
    //
    //            //4. Start the task
    //            task.resume()
    //        }
    //    }
    
    //    func parseJSON(_ fieldsData: Data)->FieldsModel?{
    //
    //        let decoder = JSONDecoder()
    //        do{
    //            let decodedData = try decoder.decode([FieldsData].self, from: fieldsData)
    //            var coordinates = [[[Double]]]()
    //            var name = [String]()
    //            var id = [String]()
    //            var center = [[Double]]()
    //            var area = [Double]()
    //
    //            decodedData.forEach { FieldsData in
    //                id += [FieldsData.id]
    //                name += [FieldsData.name]
    //                coordinates += FieldsData.geoJSON.geometry.coordinates
    //                center += [FieldsData.center]
    //                area += [FieldsData.area]
    //            }
    //            let fields = FieldsModel(mdlName: name, mdlArea: area, mdlCoordinates: coordinates, mdlId: id, mdlCenter: center)
    //            return fields
    //        } catch {
    //            delegate?.didFailWithError(error: error)
    //            print("FieldsManager - \(error)")
    //            return nil
    //        }
    //    }
    
    
    //****************************************
    
    func fetchGenericData<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
        
        let url = URL(string: urlString)
        print(url)
        URLSession.shared.dataTask(with: url!) { (data, resp, err) in
            if let err = err {
                print("Failed to fetch data:", err)
                return
            }
            guard let data = data else { return }
            
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj)
            } catch let jsonErr {
                print("Failed to decode json:", jsonErr)
            }
        }.resume()
        
        
    }
    
}
