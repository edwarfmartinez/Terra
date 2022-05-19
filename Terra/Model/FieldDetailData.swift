//
//  FieldDetailData.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 17/05/22.
//

import Foundation
import Foundation

// MARK: - Field
struct FieldDetailData: Codable {
    let dt: Int
    let type: String
    let dc: Int
    let cl: Double
    let sun: Sun
    let image, tile, stats, data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let truecolor, falsecolor: String?
    let ndvi, evi, evi2, nri: String
    let dswi, ndwi: String
}

// MARK: - Sun
struct Sun: Codable {
    let elevation, azimuth: Double
}

typealias FieldsList = [FieldDetailData]
