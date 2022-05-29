//
//  SoilData.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 24/05/22.
//

import Foundation

// MARK: - Fields
struct SoilData: Codable {
    let dt: Int
    let t10, moisture, t0: Double
}
