//
//  FieldsManager.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import Foundation

protocol TerraManagerDelegate {
    func didUpdateFields(_ terraManager: TerraManager, fields: FieldsModel)
    func didFailWithError(error: Error)
}

struct TerraManager {
    
    var delegate : TerraManagerDelegate?
    var fieldsURL : String?
    var apiKey : String?
    
    mutating func getUrl(){
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
        
        let urlString = "\(fieldsURL!)\(apiKey!)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String)
    {
        //1. Create a Url
        
        if let url = URL(string: urlString){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let fields = self.parseJSON(safeData){
                        self.delegate?.didUpdateFields(self, fields:fields)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ fieldsData: Data)->FieldsModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([FieldsData].self, from: fieldsData)
            var coordinates = [[[Double]]]()
            var name = [String]()
            var id = [String]()
            var center = [[Double]]()
            var area = [Double]()
            
            decodedData.forEach { FieldsData in
                id += [FieldsData.id]
                name += [FieldsData.name]
                coordinates += FieldsData.geoJSON.geometry.coordinates
                center += [FieldsData.center]
                area += [FieldsData.area]
            }
            let fields = FieldsModel(mdlName: name, mdlArea: area, mdlCoordinates: coordinates, mdlId: id, mdlCenter: center)
            return fields
        } catch {
            delegate?.didFailWithError(error: error)
            print("FieldsManager - \(error)")
            return nil
        }
    }
    
}
