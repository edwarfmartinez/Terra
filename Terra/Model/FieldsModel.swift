//
//  FieldsModel.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//


import Foundation


struct FieldsModel
{
    
    var mdlName: [String]?
    var mdlArea: [Double]?
    var mdlCoordinates: [[[[Double]]]]?
    var mdlId: [String]?
    var mdlCenter: [[Double]]?
    
    init(mdlName:[String]?=[], mdlArea: [Double]?=[], mdlCoordinates: [[[[Double]]]]?=[], mdlId: [String]?=[], mdlCenter: [[Double]]?=[]){
        
        self.mdlName = mdlName
        self.mdlArea = mdlArea
        self.mdlCoordinates = mdlCoordinates
        self.mdlId = mdlId
        self.mdlCenter = mdlCenter
    }
    
}

