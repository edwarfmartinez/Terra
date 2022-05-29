//
//  FieldsData.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import UIKit
import Foundation

// MARK: - Field
struct FieldsData: Codable{
    let id: String
    let geoJSON: GeoJSON
    let name: String
    let center: [Double]
    let area: Double
    let userID: String
    let createdAt: Int
    
    
    enum CodingKeys: String, CodingKey {
    
        case id
        case geoJSON = "geo_json"
        case name, center, area
        case userID = "user_id"
        case createdAt = "created_at"
    }
    
}


// MARK: - GeoJSON
struct GeoJSON: Codable {
    let id, type: String
    let properties: Properties
    let geometry: Geometry
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String
    let coordinates: [[[Double]]]
}

// MARK: - Properties
struct Properties: Codable {
}

typealias FieldData = [FieldsData]

